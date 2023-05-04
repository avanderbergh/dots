{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../modules/nixos/optional/desktop.nix
    ../modules/nixos/optional/ephemeral-btrfs.nix
    ../modules/nixos/optional/fingerprint.nix
    ../modules/nixos/optional/hidpi.nix
    ../modules/nixos/optional/laptop.nix
    ../modules/nixos/optional/ledger-live.nix
    ../modules/nixos/optional/optin-persistence.nix
    ../modules/nixos/optional/pipewire.nix
    ../modules/nixos/optional/secureboot.nix
  ];

  networking.hostName = "zoidberg";

  boot = {
    extraModulePackages = [];
    initrd = {
      availableKernelModules = ["xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
      kernelModules = ["tpm_tis"];
      luks.devices."enc".device = "/dev/disk/by-label/luks";
    };
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };
  swapDevices = [
    {
      device = "/swap/swapfile";
      size = (1024 * 32) + (1024 * 2);
    }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  system.stateVersion = "23.05";
}
