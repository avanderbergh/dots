{
  services.sxhkd = {
    enable = true;
    keybindings = {
      # 🚀 Launcher
      "super + space" = "rofi -show drun";
      "super + Return" = "alacritty";

      # 🪟 Window Management
      "super + {h,j,k,l}" = "bspc node --focus {west,south,north,east}";
      "super + shift + {h,j,k,l}" = "bspc node --swap {west,south,north,east} --follow";
      "super + ctrl + {h,j,k,l}" = "bspc node --resize {left -20 0,bottom 0 20,top 0 -20,right 20 0}";
      "super + {_,shift + }w" = "bspc node --{close,kill}";
      "super + {f,t}" = "bspc node --state {floating, tiled}";
      "super + shift + f" = "bspc node --state fullscreen";

      # 🖥️ Desktop Management
      "super + {1-9}" = "bspc desktop --focus ^{1-9}";
      "super + tab" = "bspc desktop --layout next";

      # 🔄 Reload Configurations
      "super + shift + r" = "pkill -USR1 polybar; notify-send 'Polybar' 'Configuration reloaded'";
      "super + ctrl + r" = "bspc wm -r; notify-send 'bspwm' 'Configuration reloaded'";
    };
  };
}
