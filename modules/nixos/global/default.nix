{
  lib,
  pkgs,
  colors,
  inputs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.home-manager.nixosModules.home-manager
    ./fonts.nix
    ./networking.nix
    ./nix.nix
    ./openssh.nix
    ./security.nix
    ./sops.nix
    ./systemd-boot.nix
    ./users.nix
  ];

  users.users.root.hashedPasswordFile = "/persist/passwords/root";

  # time.timeZone = "Europe/Berlin";
  services.automatic-timezoned.enable = true;
  i18n.defaultLocale = "en_US.UTF-8";

  console.useXkbConfig = true;

  programs = {
    fish.enable = true;
    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-gnome3;
      enableSSHSupport = true;
      enableExtraSocket = true;
    };
  };

  services.udisks2.enable = true;

  environment = {
    systemPackages = with pkgs; [
      dconf
      git
      gtk-engine-murrine
      libnotify
      libusb1
      libudev-zero
      parted
      pass
      pciutils
      pinentry
      pinentry-curses
      pinentry-gtk2
      pinentry-gnome3
      sbctl
      gcc
      libGLU
      libGL
      glib
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowCuda = true;
  };
}
