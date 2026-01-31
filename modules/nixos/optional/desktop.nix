{
  pkgs,
  colors,
  ...
}: {
  boot.plymouth.enable = true;

  services.xserver = {
    enable = true;
    xkb.options = "compose:ralt,ctrl:nocaps";
    displayManager = {
      lightdm = {
        enable = true;
        greeters = {
          gtk = {
            enable = true;
            extraConfig = ''
              [greeter]
              xft-dpi = 261
            '';
          };
        };
      };
    };
    windowManager.bspwm.enable = true;
    xautolock = {
      enable = true;
      locker = "${pkgs.i3lock-color}/bin/i3lock-color --blur=15";
      nowlocker = "${pkgs.i3lock-color}/bin/i3lock-color --blur=15";
      notifier = "${pkgs.libnotify}/bin/notify-send -u critical -t 10000 -- 'Locking screen in 10 seconds'";
    };
  };
  programs.i3lock = {
    enable = true;
    package = pkgs.i3lock-color;
  };

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

  environment.systemPackages = [
    pkgs.networkmanagerapplet
  ];
}
