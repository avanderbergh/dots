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
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        # Add libraries needed by dynamically linked executables here
        stdenv.cc.cc # Basic C library
        # Add other libraries as needed, e.g.:
        # openssl
        # zlib
      ];
    };
  };

  services.udisks2.enable = true;

  environment = {
    pathsToLink = ["/bin"];
    systemPackages = with pkgs; [
      dconf
      coreutils
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
