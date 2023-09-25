{lib, ...}: {
  imports = [
    ../modules/nixos/optional/ausweisapp.nix
    ../modules/nixos/optional/desktop.nix
    ../modules/nixos/optional/docker.nix
    ../modules/nixos/optional/ephemeral-btrfs.nix
    ../modules/nixos/optional/ledger-live.nix
    ../modules/nixos/optional/optin-persistence.nix
    ../modules/nixos/optional/pipewire.nix
    ../modules/nixos/optional/postgres.nix
    ../modules/nixos/optional/secureboot.nix
  ];

  networking.hostName = "hermes";

  services.xserver = {
    dpi = 109;
    resolutions = [
      {
        x = 5120;
        y = 1440;
      }
    ];
  };

  boot = {
    extraModulePackages = [];
    initrd = {
      availableKernelModules = ["xhci_pci" "nvme" "usb_storage" "sd_mod" "usbhid" "ahci"];
      kernelModules = ["tpm_tis"];
      luks.devices."enc".device = "/dev/disk/by-label/luks";
    };
    kernelModules = ["kvm-amd"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };
  swapDevices = [
    {
      device = "/swap/swapfile";
      size = (1024 * 16) + (1024 * 2);
    }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "23.05";
}
