# The Default Configuration for all my NixOS machines

{ inputs, config, lib, modulesPath, pkgs, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # 🖥 Hardware Settings

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  networking = {
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
  };

  hardware = {
    enableAllFirmware = true;

    bluetooth = {
      enable = false;
      package = pkgs.bluez;
    };

    nvidia = {
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      powerManagement.enable = true;
    };

    opengl = {
      enable = true;
      extraPackages = with pkgs; [ nvidia-vaapi-driver vaapiVdpau ];
    };

    i2c.enable = true;
    pulseaudio.enable = false;
  };

  # 💽 OS Settings

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  users = {
    mutableUsers = false;
    users = {
      avanderbergh = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" ];
        passwordFile = "/persist/passwords/avanderbergh";
        shell = pkgs.fish;
      };
      root.passwordFile = "/persist/passwords/root";
    };
  };

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

  services = {
    blueman.enable = true;
    flatpak.enable = true;
    udev.packages = with pkgs; [ yubikey-personalization ];

    pipewire = {
      enable = true;
      jack.enable = true;
      pulse.enable = true;

      alsa = {
        enable = true;
        support32Bit = true;
      };
    };

    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
    };
  };

  environment = {
    systemPackages = with pkgs; [
      sbctl
      pciutils
      pinentry
      pinentry-gtk2
      pinentry-curses
      polkit_gnome
      pass
    ];
  };

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

  security.polkit.enable = true;

  # ❄ Nix Settings

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      substituters =
        [ "https://hyprland.cachix.org" "" "https://cache.nixos.org" "" ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
      trusted-users = [ "root" "avanderbergh" ];
    };
  };

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "23.05";

  systemd.services.systemd-udevd.restartIfChanged = false;

}
