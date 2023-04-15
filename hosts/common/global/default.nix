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
  ];

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs colors;};
  };

  users.users.root.passwordFile = "/persist/passwords/root";

  time.timeZone = "Europe/Berlin";
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

  environment = {
    systemPackages = with pkgs; [
      dconf
      gtk-engine-murrine
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
