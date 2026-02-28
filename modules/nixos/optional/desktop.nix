{
  pkgs,
  inputs,
  ...
}: {
  boot.plymouth.enable = true;

  nixpkgs.overlays = [inputs.niri.overlays.niri];

  programs.niri = {
    enable = true;
    package = pkgs.niri-stable;
  };

  niri-flake.cache.enable = true;

  services = {
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
      defaultSession = "niri";
    };

    gnome = {
      gnome-keyring.enable = true;
      # Keep keyring secrets support, but avoid stealing SSH_AUTH_SOCK from gpg-agent.
      gcr-ssh-agent.enable = false;
    };
  };

  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

  environment.etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json".text = builtins.toJSON {
    rules = [
      {
        pattern = {
          feature = "procname";
          matches = "niri";
        };
        profile = "Limit Free Buffer Pool On Wayland Compositors";
      }
    ];
    profiles = [
      {
        name = "Limit Free Buffer Pool On Wayland Compositors";
        settings = [
          {
            key = "GLVidHeapReuseRatio";
            value = 0;
          }
        ];
      }
    ];
  };

  programs.gnupg.agent.pinentryPackage = pkgs.pinentry-gnome3;

  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    cursor = {
      package = pkgs.catppuccin-cursors.mochaMauve;
      name = "catppuccin-mocha-mauve-cursors";
      size = 64;
    };
    fonts = {
      serif = {
        package = pkgs.recursive;
        name = "RecMonoCasual Nerd Font Propo";
      };

      sansSerif = {
        package = pkgs.recursive;
        name = "RecMonoLinear Nerd Font Propo";
      };

      monospace = {
        package = pkgs.recursive;
        name = "RecMonoLinear Nerd Font Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        popups = 32;
      };
    };
    opacity = {
      popups = 0.9;
      terminal = 0.75;
    };
    image = ../../hm/desktop/images/wallpaper.jpg;
  };

  environment.systemPackages = with pkgs; [
    dconf
    gtk-engine-murrine
    libnotify
    networkmanagerapplet
    xwayland-satellite
  ];
}
