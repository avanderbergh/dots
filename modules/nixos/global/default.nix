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
    inputs.stylix.nixosModules.stylix
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

  time.timeZone = "Europe/Berlin";
  # services.automatic-timezoned.enable = true;
  i18n.defaultLocale = "en_US.UTF-8";

  console.useXkbConfig = true;

  # Disable the sudo lecture
  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';

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
      pinentry-all
      sbctl
      gcc
      libGLU
      libGL
      glib
    ];
  };
}
