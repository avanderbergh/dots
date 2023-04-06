{ config, lib, pkgs, ...} :

{

  networking.hostName = "zoidberg";

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ "tpm_tis" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/411e8516-a18c-42b1-b225-7efe702f4a9d";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" "noatime" ];
    };

  boot.initrd.luks.devices."enc".device = "/dev/disk/by-uuid/b9237f83-f195-4545-9bad-ee84c018d8cd";

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/411e8516-a18c-42b1-b225-7efe702f4a9d";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" "noatime" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/411e8516-a18c-42b1-b225-7efe702f4a9d";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };

  fileSystems."/persist" =
    { device = "/dev/disk/by-uuid/411e8516-a18c-42b1-b225-7efe702f4a9d";
      fsType = "btrfs";
      options = [ "subvol=persist" "compress=zstd" "noatime" ];
      neededForBoot = true;
    };

  fileSystems."/var/log" =
    { device = "/dev/disk/by-uuid/411e8516-a18c-42b1-b225-7efe702f4a9d";
      fsType = "btrfs";
      options = [ "subvol=log" "compress=zstd" "noatime" ];
      neededForBoot = true;
    };

  fileSystems."/swap" =
    { device = "/dev/disk/by-uuid/411e8516-a18c-42b1-b225-7efe702f4a9d";
      fsType = "btrfs";
      options = [ "subvol=swap" "noatime" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/246D-DA90";
      fsType = "vfat";
    };

  swapDevices = [{
    device = "/swap/swapfile";
    size = (1024 * 32) + (1024 * 2);
  }];

  services.fprintd = {
    enable = true;
    tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-goodix;
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}