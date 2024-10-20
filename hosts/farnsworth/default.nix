{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/nixos/optional/home-assistant
    ../../modules/nixos/optional/media-server.nix
  ];
  networking.hostName = "farnsworth";

  boot = {
    extraModulePackages = [];
    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "ohci_pci" "ehci_pci" "usbhid" "usb_storage" "sd_mod"];
    };
    kernelModules = ["kvm-amd"];
  };

  environment = {
    systemPackages = with pkgs; [
      cryptsetup
    ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
    "/mnt/elements" = {
      device = "/dev/disk/by-label/Elements";
      fsType = "ext4";
    };
  };

  swapDevices = [{device = "/dev/disk/by-label/swap";}];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "23.11";
}
