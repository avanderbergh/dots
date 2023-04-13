{
  colors,
  config,
  ...
}: let
  inherit
    (config.colorScheme.colors)
    base00 #1e1e2e base
    base01 #181825 mantle
    base02 #313244 surface0
    base03 #45475a surface1
    base04 #585b70 surface2
    base05 #cdd6f4 text
    base06 #f5e0dc rosewater
    base07 #b4befe lavender
    base08 #f38ba8 red
    base09 #fab387 peach
    base0A #f9e2af yellow
    base0B #a6e3a1 green
    base0C #94e2d5 teal
    base0D #89b4fa blue
    base0E #cba6f7 mauve
    base0F #f2cdcd flamingo
    ;
in {
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
        background = "${colors.bg}";
        foreground = "${colors.fg}";

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
        label-focused-underline = "${base0E}";
        label-focused-foreground = "${base0E}";
        label-dimmed-underline = "${base00}";
        label-empty-foreground = "${base04}";
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
