# Configuration for the 🦀 zoidberg laptop

{ inputs, config, lib, pkgs, ... }:

{
  networking.hostName = "zoidberg";

  imports = [
    inputs.impermanence.nixosModules.impermanence
    ./modules/impermanence.nix
    ./modules/fingerprint.nix
    ./modules/wayland.nix
  ];

  boot = {
    extraModulePackages = [ ];
    initrd = {
      availableKernelModules =
        [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ "tpm_tis" ];
      luks.devices."enc".device =
        "/dev/disk/by-uuid/b9237f83-f195-4545-9bad-ee84c018d8cd";
    };
    kernelModules = [ "kvm-intel" ];
    kernelParams = [ "acpi_rev_override" ];
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

    "/boot" = {
      device = "/dev/disk/by-uuid/246D-DA90";
      fsType = "vfat";
    };

  };

  swapDevices = [{
    device = "/swap/swapfile";
    size = (1024 * 32) + (1024 * 2);
  }];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;

  services.thermald.enable = true;

}
