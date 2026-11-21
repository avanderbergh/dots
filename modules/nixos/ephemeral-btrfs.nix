{
  flake.modules.nixos."ephemeral-btrfs" = _: let
    device = "/dev/mapper/enc";
    fsType = "btrfs";
    mkOptions = subvol: ["subvol=${subvol}" "compress=zstd" "noatime"];
  in {
    boot.initrd = {
      supportedFilesystems = ["btrfs"];
      systemd = {
        services = {
          rollback = {
            description = "Rollback BTRFS root subvolume to a pristine state";
            wantedBy = ["initrd.target"];
            after = ["systemd-cryptsetup@enc.service"];
            before = ["sysroot.mount"];
            unitConfig.DefaultDependencies = "no";
            serviceConfig.Type = "oneshot";
            script = ''
              set -eu
              mkdir -p /mnt
              mount -o subvol=/ ${device} /mnt
              trap 'umount /mnt || true' EXIT

              if [ -d /mnt/root ]; then
                subvols=$(btrfs subvolume list -o /mnt/root)
                if [ -n "$subvols" ]; then
                  printf '%s\n' "$subvols" |
                    while IFS= read -r line; do
                      printf '%s\n' "''${line#* path }"
                    done |
                    sort -r |
                    while IFS= read -r subvolume; do
                      echo "deleting /$subvolume subvolume..."
                      btrfs subvolume delete "/mnt/$subvolume"
                    done
                fi
                echo "deleting /root subvolume..."
                btrfs subvolume delete /mnt/root
              fi

              echo "restoring blank /root subvolume..."
              btrfs subvolume snapshot /mnt/root-blank /mnt/root
            '';
          };
          persisted-files = {
            description = "Symlink persisted files from /persist";
            wantedBy = ["initrd.target"];
            after = ["sysroot.mount"];
            unitConfig.DefaultDependencies = "no";
            serviceConfig.Type = "oneshot";
            script = ''
              set -eu
              mkdir -p /sysroot/etc
              ln -snfT /persist/etc/machine-id /sysroot/etc/machine-id
            '';
          };
        };
      };
    };

    fileSystems = {
      "/" = {
        inherit device fsType;
        options = mkOptions "root";
      };

      "/home" = {
        inherit device fsType;
        options = mkOptions "home";
      };

      "/nix" = {
        inherit device fsType;
        options = mkOptions "nix";
      };

      "/persist" = {
        inherit device fsType;
        options = mkOptions "persist";
        neededForBoot = true;
      };

      "/var/log" = {
        inherit device fsType;
        options = mkOptions "log";
        neededForBoot = true;
      };

      "/swap" = {
        inherit device fsType;
        options = ["subvol=swap" "noatime"];
      };
    };
  };
}
