{pkgs, ...}: {
  imports = [./polybar.nix];

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
      "super + Return" = "alacritty";

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
    cursorTheme = {
      name = "Catppuccin-Mocha-Dark-Cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 48;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
  };
}
