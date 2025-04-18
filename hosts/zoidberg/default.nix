{lib, ...}: {
  imports = [
    ../../modules/nixos/optional/ausweisapp.nix
    ../../modules/nixos/optional/bluetooth.nix
    ../../modules/nixos/optional/desktop.nix
    ../../modules/nixos/optional/docker.nix
    ../../modules/nixos/optional/ephemeral-btrfs.nix
    ../../modules/nixos/optional/laptop.nix
    ../../modules/nixos/optional/ledger-live.nix
    ../../modules/nixos/optional/ollama.nix
    ../../modules/nixos/optional/optin-persistence.nix
    ../../modules/nixos/optional/pipewire-sof-workarounds.nix
    ../../modules/nixos/optional/pipewire.nix
    ../../modules/nixos/optional/postgres.nix
    ../../modules/nixos/optional/secureboot.nix
    ../../modules/nixos/optional/vpn.nix
    ../../modules/nixos/optional/yubikey.nix
  ];

  networking.hostName = "zoidberg";

  boot = {
    extraModulePackages = [];
    initrd = {
      availableKernelModules = ["xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
      kernelModules = ["tpm_tis"];
      luks.devices."enc".device = "/dev/disk/by-label/luks";
    };
    kernelModules = ["btintel"];
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

  hardware.nvidia = {
    open = true;
    prime = {
      offload.enable = false;
      sync.enable = true;
      nvidiaBusId = lib.mkDefault "PCI:1:0:0";
      intelBusId = lib.mkDefault "PCI:0:2:0";
    };
  };

  programs.nh.flake = "/home/avanderbergh/repos/github.com/avanderbergh/dots/";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  system.stateVersion = "23.11";
}
