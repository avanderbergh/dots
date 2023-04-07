{ config, lib, modulesPath, pkgs, ...}:

{  
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  users.mutableUsers = false;
  users.users.root.passwordFile = "/persist/passwords/root";

  users.users.avanderbergh = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    passwordFile = "/persist/passwords/avanderbergh";
    packages = with pkgs; [
      google-chrome
      firefox
      thunderbird
    ];
  };

  time.timeZone = "Europe/Berlin";
  
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  services.udev.packages = [ pkgs.yubikey-personalization ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.fish.enable = true;
  users.users.avanderbergh.shell = pkgs.fish;

  programs.hyprland.enable = true;

  services.gnome.gnome-keyring.enable = lib.mkForce false;

  environment.systemPackages = with pkgs; [
    bitwarden
    git
    neovim
    sbctl
    vim
    wget
  ];

  services.openssh.enable = true;
  services.printing.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.libinput.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.enableAllFirmware = true;

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      victor-mono
      roboto
      roboto-slab
      noto-fonts-emoji
      (nerdfonts.override { fonts = [ "VictorMono" "Noto" ]; })
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Roboto Slab" ];
        sansSerif = [ "Roboto" ];
        monospace = [ "Victor Mono" ];
      };

      antialias = true;
      subpixel = {
        rgba = "none";
        lcdfilter = "none";
      };
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  networking.useDHCP = lib.mkDefault true;
  networking.networkmanager.enable = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };


  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "22.11";
}
