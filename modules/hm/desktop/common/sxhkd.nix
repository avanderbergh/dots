{
  services.sxhkd = {
    enable = true;
    keybindings = {
      # 🚀 Launcher
      "super + space" = "rofi -show drun";
      "super + shift + space" = "rofi -show window";
      "super + Return" = "alacritty";
      "super + e" = "rofi -modi emoji -show emoji";
      "super + o" = "code $GHQ_ROOT/(ghq list | rofi -dmenu)";
      "super + b" = "google-chrome-stable";
      "super + slash" = "pcmanfm";

      # 🪟 Window Management
      "super + {h,j,k,l}" = "bspc node --focus {west,south,north,east}";
      "super + shift + {h,j,k,l}" = "bspc node --swap {west,south,north,east} --follow";
      "super + ctrl + {h,j,k,l}" = "bspc node --resize {left -20 0,bottom 0 20,top 0 -20,right 20 0}";
      "super + ctrl + shift + {h,j,k,l}" = "bspc node --resize {right -20 0,top 0 20,bottom 0 -20,left 20 0}";
      "super + {Left,Down,Up,Right}" = "bspc node --move {-20 0,0 20,0 -20,20 0}";
      "super + {_,shift + }w" = "bspc node --{close,kill}";
      "super + {f,t}" = "bspc node --state {floating, tiled}";
      "super + shift + f" = "bspc node --state fullscreen";

      # 🖥️ Desktop Management
      "super + {1-6}" = "bspc desktop --focus ^{1-6}";
      "super + bracket{left,right}" = "bspc desktop --focus {prev,next}.local";
      "super + shift + {1-6}" = "bspc node --to-desktop ^{1-6} --follow";
      "super + Tab" = "bspc desktop --layout next";

      # 🔄 Reload Configurations
      "super + Escape" = ''
        pkill -USR1 polybar;
        pkill -USR1 -x sxhkd;
        bspc wm -r;
      '';
    };
  };
}
