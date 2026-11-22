{
  config,
  inputs,
  ...
}: let
  inherit (config.flake.modules) nixos;
in {
  flake.modules.nixos.base = {
    modulesPath,
    pkgs,
    ...
  }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
      inputs.home-manager.nixosModules.home-manager
      inputs.stylix.nixosModules.stylix
      nixos.fonts
      nixos.networking
      nixos.nix
      nixos.openssh
      nixos.sops
      nixos."systemd-boot"
      nixos.users
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
      nix-ld = {
        enable = true;
        libraries = with pkgs; [
          # Runtime libraries for dynamically linked executables (NixOS already
          # includes stdenv.cc.cc, zlib, openssl, systemd/libudev, etc. by default).
          glib
          libGL
          libGLU
          libusb1
        ];
      };
    };

    services.udisks2.enable = true;

    zramSwap.enable = true;

    environment = {
      systemPackages = with pkgs; [
        git
        parted
        pciutils
        sbctl
      ];
    };
  };
}
