{
  colors,
  config,
  ...
}: {
  services.polybar = {
    enable = true;
    config = {
      "bar/top" = {
        monitor = "eDP-1";
        width = "100%";
        height = "3%";
        dpi = 0;
        radius = 0;
        scroll-up = "#bspwm.prev";
        scroll-down = "#bspwm.next";
        tray-position = "right";
        font-0 = "VictorMono Nerd Font:size=14";
        background = "${colors.base}";
        foreground = "${colors.text}";

        modules-left = "date";
        modules-center = "bspwm";
        modules-right = "network";

        module-margin = 1;
      };
      "module/date" = {
        type = "internal/date";
        internal = 5;
        date = "%a %d %b";
        time = "%H:%M";
        label = "%date% | %time%";
      };
      "module/bspwm" = {
        type = "internal/bspwm";
        label-focused-underline = "${colors.mauve}";
        label-focused-foreground = "${colors.mauve}";
        label-dimmed-underline = "${colors.surface2}";
        label-empty-foreground = "${colors.surface2}";
      };
      "module/network" = {
        type = "internal/network";
        interface = "wlp4s0";
        interface-type = "wireless";
        label-connected = "%essid%";
        format-connected = "<ramp-signal> <label-connected>";
        ramp-signal-0 = "󰤨";
        ramp-signal-1 = "󰤥";
        ramp-signal-2 = "󰤢";
        ramp-signal-3 = "󰤟";
        ramp-signal-4 = "󰤫";
      };
      "module/battery" = {
        type = "internal/battery";
        battery = "BAT0";
        adapter = "AC";
      };
      "module/backlight" = {
        type = "internal/backlight";
        card = "intel_backlight";
        format = "<ramp>";
        ramp-0 = "🌕";
        ramp-1 = "🌔";
        ramp-2 = "🌓";
        ramp-3 = "🌒";
        ramp-4 = "🌑";
      };
    };

    script = ''
      polybar top &
    '';
  };
}
