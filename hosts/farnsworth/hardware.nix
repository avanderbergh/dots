{
  flake.modules.nixos."host-farnsworth" = {lib, ...}: {
    boot = {
      extraModulePackages = [];
      initrd = {
        availableKernelModules = ["xhci_pci" "ahci" "ohci_pci" "ehci_pci" "usbhid" "usb_storage" "sd_mod"];
      };
      kernelModules = ["kvm-amd"];
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
  };
}
