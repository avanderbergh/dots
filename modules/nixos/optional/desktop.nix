{
  pkgs,
  colors,
  ...
}: {
  boot.plymouth = {
    enable = true;
    themePackages = [pkgs.catppuccin-plymouth];
    theme = "catppuccin-mocha";
  };

  services.expressvpn.enable = true;

  services.xserver = {
    enable = true;
    xkbOptions = "compose:ralt,ctrl:nocaps";
    displayManager = {
      lightdm = {
        enable = true;
        background = "/usr/share/background.jpg";
        greeters = {
          gtk = {
            enable = true;
            theme = {
              name = "Catppuccin-Mocha-Standard-Pink-Dark";
              package = pkgs.catppuccin-gtk.override {
                accents = ["pink"];
                variant = "mocha";
              };
            };
            cursorTheme = {
              name = "Catppuccin-Mocha-Dark-Cursors";
              package = pkgs.catppuccin-cursors.mochaDark;
              size = 48;
            };
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
}
