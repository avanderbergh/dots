{ inputs, config, lib, modulesPath, pkgs, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  users.mutableUsers = false;
  users.users.root.passwordFile = "/persist/passwords/root";

  users.users.avanderbergh = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    passwordFile = "/persist/passwords/avanderbergh";
    packages = with pkgs; [ google-chrome firefox thunderbird ];
  };

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "tty";
    enableSSHSupport = true;
  };

  programs.fish.enable = true;
  users.users.avanderbergh.shell = pkgs.fish;

  programs.hyprland.enable = true;

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

    variables = {
      CLUTTER_BACKEND = "wayland";
      # DEFAULT_BROWSER = "${pkgs.firefox-nightly-bin}/bin/firefox";
      DIRENV_LOG_FORMAT = "";
      DISABLE_QT5_COMPAT = "0";
      GBM_BACKEND = "nvidia-drm";
      GDK_BACKEND = "wayland";
      GDK_SCALE = "2";
      GLFW_IM_MODULE = "ibus";
      GPG_TTY = "$TTY";
      LIBSEAT_BACKEND = "logind";
      LIBVA_DRIVER_NAME = "nvidia";
      NIXOS_OZONE_WL = "1";
      NIXPKGS_ALLOW_UNFREE = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      SDL_VIDEODRIVER = "wayland";
      WINIT_UNIX_BACKEND = "x11";
      WLR_BACKEND = "vulkan";
      WLR_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0";
      WLR_DRM_NO_ATOMIC = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
      WLR_RENDERER = "vulkan";
      XCURSOR_SIZE = "48";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      __GL_GSYNC_ALLOWED = "0";
      __GL_VRR_ALLOWED = "0";
      # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
  };

  hardware = {
    enableAllFirmware = true;

    bluetooth = {
      enable = false;
      package = pkgs.bluez;
    };

    nvidia = {
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      powerManagement.enable = true;
    };

    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [ nvidia-vaapi-driver ];
    };

    i2c.enable = true;
    pulseaudio.enable = false;
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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.useDHCP = lib.mkDefault true;
  networking.networkmanager.enable = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys =
      [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    trusted-users = [ "root" "avanderbergh" ];
  };

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "23.05";
}
