{lib, ...}: let
  device = "/dev/mapper/enc";
  fsType = "btrfs";
  mkOptions = subvol: ["subvol=${subvol}" "compress=zstd" "noatime"];
in {
  boot.initrd = {
    supportedFilesystems = ["btrfs"];
    systemd = {
      enable = lib.mkDefault true;
      services = {
        rollback = {
          description = "Rollback BTRFS root subvolume to a pristine state";
          wantedBy = ["initrd.target"];
          after = ["systemd-cryptsetup@enc.service"];
          before = ["sysroot.mount"];
          unitConfig.DefaultDependencies = "no";
          serviceConfig.Type = "oneshot";
          script = ''
            mkdir -p /mnt
            mount -o subvol=/ ${device} /mnt

            btrfs subvolume list -o /mnt/root |
              cut -f9 -d' ' |
              while read subvolume; do
                echo "deleting /$subvolume subvolume..."
                btrfs subvolume delete "/mnt/$subvolume"
              done &&
              echo "deleting /root subvolume..." &&
              btrfs subvolume delete /mnt/root
            echo "restoring blank /root subvolume..."
            btrfs subvolume snapshot /mnt/root-blank /mnt/root

            umount /mnt
          '';
        };
        persisted-files = {
          description = "Hard-link persisted files from /persist";
          wantedBy = ["initrd.target"];
          after = ["sysroot.mount"];
          unitConfig.DefaultDependencies = "no";
          serviceConfig.Type = "oneshot";
          script = ''
            mkdir -p /sysroot/etc/
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
}
