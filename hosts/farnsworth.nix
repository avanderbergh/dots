{lib, ...}: {
  imports = [
    ../modules/nixos/optional/home-assistant
  ];
  networking.hostName = "farnsworth";

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
  };

  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    #settings.PermitRootLogin = "yes";
  };

  swapDevices = [{device = "/dev/disk/by-label/swap";}];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "23.05";
}
