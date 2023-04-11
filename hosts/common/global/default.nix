{ inputs, modulesPath, outputs, pkgs, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.home-manager.nixosModules.home-manager
    ./networking.nix
    ./nix.nix
    ./nvidia.nix
    ./systemd-boot.nix
  ];

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs outputs; };
  };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  programs = {
    fish.enable = true;
    gnupg.agent = {
      enable = true;
      pinentryFlavor = "tty";
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
      polkit_gnome
      sbctl
    ];
  };

  nixpkgs.config.allowUnfree = true;
}