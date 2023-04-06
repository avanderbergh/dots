# Requires impermanence flake
{ lib, config, pkgs, ... }: {

  boot.initrd.systemd.enable = lib.mkDefault true;
  boot.initrd.systemd.services.rollback = {
    description = "Rollback BTRFS root subvolume to a pristine state";
    wantedBy = [
      "initrd.target"
    ];
    after = [
      # LUKS/TPM process
      "systemd-cryptsetup@enc.service"
    ];
    before = [
      "sysroot.mount"
    ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir -p /mnt
      # We first mount the btrfs root to /mnt
      # so we can manipulate btrfs subvolumes.
      mount -o subvol=/ /dev/mapper/enc /mnt
      # While we're tempted to just delete /root and create
      # a new snapshot from /root-blank, /root is already
      # populated at this point with a number of subvolumes,
      # which makes `btrfs subvolume delete` fail.
      # So, we remove them first.
      #
      # /root contains subvolumes:
      # - /root/var/lib/portables
      # - /root/var/lib/machines
      #
      # I suspect these are related to systemd-nspawn, but
      # since I don't use it I'm not 100% sure.
      # Anyhow, deleting these subvolumes hasn't resulted
      # in any issues so far, except for fairly
      # benign-looking errors from systemd-tmpfiles.
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
      # Once we're done rolling back to a blank snapshot,
      # we can unmount /mnt and continue on the boot process.
      umount /mnt
    '';
  };
  boot.initrd.systemd.services.persisted-files = {
    description = "Hard-link persisted files from /persist";
    wantedBy = [
      "initrd.target"
    ];
    after = [
      "sysroot.mount"
    ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir -p /sysroot/etc/
      ln -snfT /persist/etc/machine-id /sysroot/etc/machine-id
    '';
  };

  # symlinks to enable "erase your darlings"
  environment.persistence."/persist" = {
    directories = [
      "/etc/NetworkManager/system-connections"
      "/var/lib/bluetooth"
      "/var/lib/boltd/"
      "/var/lib/colord"
      "/var/lib/systemd/coredump"
      "/var/lib/systemd/rfkill/"
      "/var/lib/NetworkManager/"
      "/var/lib/upower"
    ];
    files = [
      "/etc/group"
      "/etc/machine-id"
      "/etc/passwd"
      "/etc/shadow"
      "/etc/subgid"
      "/etc/subuid"
      "/etc/sudoers"
      "/var/lib/alsa/asound.state"
      "/var/lib/power-profiles-daemon/state.ini"
    ];
  };

}