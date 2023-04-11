{ pkgs, ... }: {

  xsession = {
    enable = true;
    windowManager.bspwm = {
      enable = true;
      monitors = {
        "eDP-1" = [ "web" "code" "term" "files" "music" "chat" "media" "misc" ];
      };
    };
  };

  services.sxhkd = {
    enable = true;
    keybindings = { "super + space" = "rofi -show drun"; };
  };

  services.polybar = {
    enable = true;
    config = {
      "bar/top" = {
        monitor = "eDP-1";
        width = "100%";
        height = "3%";
        radius = 0;
        modules-center = "date";
      };
      "module/date" = {
        type = "internal/date";
        internal = 5;
        date = "%d.%m.%y";
        time = "%H:%M";
        label = "%time%  %date%";
      };
      script = ''
        polybar top & \n
        echo "Polybar launched..."
      '';
    };
  };
  programs.rofi.enable = true;

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Pink-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "pink" ];
        variant = "mocha";
      };
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
  };

}
