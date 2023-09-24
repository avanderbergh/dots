{
  lib,
  pkgs,
  colors,
  inputs,
  outputs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.home-manager.nixosModules.home-manager
    ./fonts.nix
    ./networking.nix
    ./nix.nix
    ./security.nix
    ./systemd-boot.nix
    ./users.nix
  ];

  users.users.root.hashedPasswordFile = "/persist/passwords/root";

  # time.timeZone = "Europe/Berlin";
  services.automatic-timezoned.enable = true;
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = lib.mkDefault "Lat2-Terminus16";
    useXkbConfig = true;
  };

  programs = {
    fish.enable = true;
    gnupg.agent = {
      enable = true;
      pinentryFlavor = "gtk2";
      enableSSHSupport = true;
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
      sbctl
    ];
  };

  nixpkgs.config.allowUnfree = true;
}
