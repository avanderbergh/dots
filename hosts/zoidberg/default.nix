{ inputs, config, lib, pkgs, ... }: {

  imports = [
    inputs.nixos-hardware.nixosModules.dell-xps-17-9700-nvidia

    ../common/global

    ../common/users/avanderbergh

    ../common/optional/desktop.nix
    ../common/optional/ephemeral-btrfs.nix
    ../common/optional/fingerprint.nix
    ../common/optional/hidpi.nix
    ../common/optional/optin-persistence.nix
    ../common/optional/pipewire.nix
  ];

  networking.hostName = "zoidberg";

  boot = {
    extraModulePackages = [ ];
    initrd = {
      availableKernelModules =
        [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ "tpm_tis" ];
      luks.devices."enc".device =
        "/dev/disk/by-uuid/b9237f83-f195-4545-9bad-ee84c018d8cd";
    };
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/246D-DA90";
    fsType = "vfat";
  };
  swapDevices = [{
    device = "/swap/swapfile";
    size = (1024 * 32) + (1024 * 2);
  }];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  system.stateVersion = "23.05";
}
