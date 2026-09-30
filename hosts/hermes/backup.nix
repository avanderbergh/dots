{
  flake.modules.nixos."host-hermes" = {
    config,
    lib,
    pkgs,
    ...
  }: let
    ownerHome = config.users.users.${config.local.users.ownerName}.home;
    sourceMount = "/mnt/backup-source";
    targetMount = "${ownerHome}/hdd";
    targetDevice = config.fileSystems.${targetMount}.device;
    targetDirectory = "${targetMount}/backups/${config.networking.hostName}";
    snapshotDirectory = "${sourceMount}/backup-snapshots";
    checkSpace = pkgs.writeShellApplication {
      name = "backup-space-check";
      runtimeInputs = [pkgs.btrfs-progs pkgs.coreutils pkgs.gawk pkgs.util-linux];
      text = ''
        failed=0
        for filesystem in ${lib.escapeShellArgs [sourceMount targetMount]}; do
          mountpoint -q "$filesystem"
          usage=$(btrfs filesystem usage -b "$filesystem")
          printf '%s\n%s\n' "$filesystem" "$usage"
          size=$(awk '/Device size:/ {print $3}' <<< "$usage")
          unallocated=$(awk '/Device unallocated:/ {print $3}' <<< "$usage")
          available=$(df -B1 --output=avail "$filesystem" | tail -n 1)
          # These are conservative policy margins, not Btrfs guarantees.
          # Metadata percentage alone is misleading while chunks can grow.
          if [[ ! "$size" =~ ^[0-9]+$ || ! "$unallocated" =~ ^[0-9]+$ ]]; then
            echo "Cannot determine Btrfs allocation headroom: $filesystem" >&2
            exit 1
          fi
          if (( unallocated < 20 * 1024 * 1024 * 1024 || available < size / 5 )); then
            echo "Low Btrfs headroom: $filesystem; need 20 GiB unallocated and 20% free. Inspect before taking more snapshots." >&2
            failed=1
          fi
        done
        exit "$failed"
      '';
    };
  in {
    environment.systemPackages = [pkgs.smartmontools];

    # View the NVMe's top-level subvolumes without traversing mounts in /home.
    fileSystems.${sourceMount} = {
      inherit (config.fileSystems."/home") device fsType;
      options = ["subvolid=5" "noatime"];
    };

    services = {
      btrbk.instances.local = {
        onCalendar = "*-*-* 03:00:00";
        settings = {
          backend = "btrfs-progs";
          timestamp_format = "long-iso";
          snapshot_create = "ondemand";
          snapshot_preserve_min = "latest";
          snapshot_preserve = "no";
          target_preserve_min = "latest";
          target_preserve = "7d 4w 3m";
          volume.${sourceMount} = {
            snapshot_dir = snapshotDirectory;
            target = targetDirectory;
            subvolume = {
              home = {};
              persist = {};
            };
          };
        };
      };

      # Each backup waits for a fresh, successful logical dump. Keeping it in
      # /persist also preserves it across the ephemeral-root rollback.
      postgresqlBackup = {
        enable = true;
        backupAll = true;
        startAt = [];
        location = "/persist/backup/postgresql";
      };

      # One scrub per physical filesystem, not one per NVMe subvolume.
      btrfs.autoScrub = {
        enable = true;
        interval = "monthly";
        fileSystems = ["/home" targetMount "${ownerHome}/ssd"];
      };
      smartd.enable = true;
    };

    systemd = {
      services = {
        backup-space-check = {
          description = "Check Btrfs allocation headroom for local backups";
          unitConfig.RequiresMountsFor = [sourceMount targetMount];
          serviceConfig = {
            Type = "oneshot";
            ExecStart = lib.getExe checkSpace;
          };
        };

        postgresqlBackup = {
          requires = ["backup-space-check.service"];
          after = ["backup-space-check.service" "postgresql.service"];
        };

        btrbk-local = {
          requires = ["backup-space-check.service" "postgresqlBackup.service"];
          after = ["backup-space-check.service" "postgresqlBackup.service"];
          unitConfig.RequiresMountsFor = [sourceMount targetMount];
          path = [pkgs.coreutils pkgs.util-linux];
          # Local root avoids granting the backup account access through private
          # home directories and lets the destination stay root-only.
          serviceConfig = {
            User = lib.mkForce "root";
            Group = lib.mkForce "root";
            UMask = "0077";
          };
          preStart = ''
            set -eu
            source_uuid=$(findmnt -nro UUID --target ${lib.escapeShellArg sourceMount})
            target_uuid=$(findmnt -nro UUID --target ${lib.escapeShellArg targetMount})
            expected_uuid=$(blkid -s UUID -o value ${lib.escapeShellArg targetDevice})
            if [ -z "$source_uuid" ] || [ -z "$target_uuid" ] \
              || [ "$target_uuid" != "$expected_uuid" ] \
              || [ "$source_uuid" = "$target_uuid" ]; then
              echo "Backup refused: expected a separate, mounted backup disk." >&2
              exit 1
            fi
            install -d -m 0700 ${lib.escapeShellArg snapshotDirectory} ${lib.escapeShellArg targetDirectory}
          '';
        };
      };
      timers.backup-space-check = {
        wantedBy = ["timers.target"];
        timerConfig = {
          OnCalendar = "hourly";
          Persistent = true;
        };
      };
    };
  };
}
