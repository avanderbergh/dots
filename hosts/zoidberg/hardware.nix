{
  flake.modules.nixos."host-zoidberg" = {lib, ...}: {
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

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  };
}
