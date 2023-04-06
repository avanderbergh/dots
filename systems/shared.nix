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

  services.gnome.gnome-keyring.enable = lib.mkForce false;

  environment.systemPackages = with pkgs; [
    bitwarden
    git
    neovim
    sbctl
    vim
    wget
  ];

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.layout = "us";
  services.openssh.enable = true;
  services.printing.enable = true;
  services.xserver.libinput.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.enableAllFirmware = true;


  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  networking.useDHCP = lib.mkDefault true;
  networking.networkmanager.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "22.11";
}
