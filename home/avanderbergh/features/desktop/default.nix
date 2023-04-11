{pkgs, ...}: {
  xsession = {
    enable = true;
    windowManager.bspwm = {
      enable = true;
      monitors = {"eDP-1" = ["code" "web" "chat" "music" "prod"];};
    };
  };

  services.sxhkd = {
    enable = true;
    keybindings = {
      "super + space" = "rofi -show drun";
      "super + enter" = "alacritty";

      # Move between windows
      "super + {h,j,k,l}" = "bspc node -f {west,south,north,east}";
      # Swap windows
      "super + shift + {h,j,k,l}" = "bspc node --swap {west,south,north,east} --follow";
      # Resize windows
      "super + ctrl + {h,j,k,l}" = "bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}";
      # Close or kill focused window
      "super + {_,shift + }w" = "bspc node -{c,k}";
    };
  };

  services.polybar = {
    enable = true;
    config = {
      "bar/top" = {
        monitor = "eDP-1";
        width = "100%";
        height = "3%";
        radius = 0;
        modules-left = "bspwm";
        modules-center = "date";
        scroll-up = "#bspwm.prev";
        scroll-down = "#bspwm.next";
      };
      "module/date" = {
        type = "internal/date";
        internal = 5;
        date = "%d.%m.%y";
        time = "%H:%M";
        label = "%time%  %date%";
      };
      "module/bspwm" = {
        type = "internal/bspwm";
        ws-icon-0 = "code;♚";
        ws-icon-1 = "web;♛";
        ws-icon-2 = "chat;♜";
        ws-icon-3 = "music;♝";
        ws-icon-4 = "prod;♞";
        ws-icon-default = "♟";
      };
    };
    script = ''
      polybar top &
    '';
  };
  programs.rofi.enable = true;

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Pink-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = ["pink"];
        variant = "mocha";
      };
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
  };
}
