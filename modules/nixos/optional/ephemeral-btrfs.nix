{ lib, config, pkgs, ... }: {

  boot.initrd = {
    supportedFilesystems = [ "btrfs" ];
    systemd = {
      enable = lib.mkDefault true;
      services = {
        rollback = {
          description = "Rollback BTRFS root subvolume to a pristine state";
          wantedBy = [ "initrd.target" ];
          after = [ "systemd-cryptsetup@enc.service" ];
          before = [ "sysroot.mount" ];
          unitConfig.DefaultDependencies = "no";
          serviceConfig.Type = "oneshot";
          script = ''
            mkdir -p /mnt
            mount -o subvol=/ /dev/mapper/enc /mnt

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
          wantedBy = [ "initrd.target" ];
          after = [ "sysroot.mount" ];
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
      device = "/dev/disk/by-uuid/411e8516-a18c-42b1-b225-7efe702f4a9d";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" "noatime" ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/411e8516-a18c-42b1-b225-7efe702f4a9d";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" "noatime" ];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/411e8516-a18c-42b1-b225-7efe702f4a9d";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };

    "/persist" = {
      device = "/dev/disk/by-uuid/411e8516-a18c-42b1-b225-7efe702f4a9d";
      fsType = "btrfs";
      options = [ "subvol=persist" "compress=zstd" "noatime" ];
      neededForBoot = true;
    };

    "/var/log" = {
      device = "/dev/disk/by-uuid/411e8516-a18c-42b1-b225-7efe702f4a9d";
      fsType = "btrfs";
      options = [ "subvol=log" "compress=zstd" "noatime" ];
      neededForBoot = true;
    };

    "/swap" = {
      device = "/dev/disk/by-uuid/411e8516-a18c-42b1-b225-7efe702f4a9d";
      fsType = "btrfs";
      options = [ "subvol=swap" "noatime" ];
    };
  };

}

