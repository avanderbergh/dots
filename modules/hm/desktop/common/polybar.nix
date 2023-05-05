{
  colors,
  monitor,
  config,
  ...
}: {
  services.polybar = {
    enable = true;
    config = {
      "bar/top" = {
        inherit monitor;
        width = "100%";
        height = "3%";
        dpi = 0;
        radius = 0;
        scroll-up = "#bspwm.prev";
        scroll-down = "#bspwm.next";
        tray-position = "right";
        font-0 = "Victor Mono:size=14;3";
        font-1 = "VictorMono Nerd Font Mono:size=32;20";
        font-2 = "VictorMono Nerd Font Mono:size=22;14";
        background = "#00000000";
        foreground = "${colors.text}";

        modules-left = "lr date rr";
        modules-center = "lr bspwm rr";
        modules-right = "lr cpu sp memory sp battery sp network rr";

        module-margin = 0;
        padding = 1;

        line-size = 3;
        line-color = "${colors.lavender}";

        border-size = 5;
        border-color = "#00000000";
      };
      "module/date" = {
        type = "internal/date";
        format-background = "${colors.base}";
        internal = 5;
        date = "%a %d %b";
        time = "%H:%M";
        label = "%{F${colors.lavender}} %date%%{F-} %{F${colors.teal}} %time%%{F-}";
      };
      "module/bspwm" = {
        type = "internal/bspwm";

        format-background = "${colors.base}";
        label-focused = "%icon%";
        label-focused-underline = "${colors.mauve}";
        label-focused-foreground = "${colors.mauve}";

        label-urgent = "%icon%";
        label-urgent-foreground = "${colors.red}";

        label-occupied = "%icon%";

        label-empty = "%icon%";
        label-empty-foreground = "${colors.surface2}";

        label-separator = " ";
        label-separator-padding = 1;

        ws-icon-0 = "code;";
        ws-icon-1 = "term;";
        ws-icon-2 = "web;󰖟";
        ws-icon-3 = "chat;󰭹";
        ws-icon-4 = "music;";
        ws-icon-5 = "prod;";
      };
      "module/network" = {
        type = "internal/network";
        format-connected-background = "${colors.base}";
        format-disconnected-background = "${colors.base}";
        interface = "wlp4s0";
        interface-type = "wireless";
        label-connected = "%downspeed:1%";
        format-connected = "%{F${colors.sky}}<ramp-signal> <label-connected>%{F-}";
        ramp-signal-0 = "󰤨";
        ramp-signal-1 = "󰤥";
        ramp-signal-2 = "󰤢";
        ramp-signal-3 = "󰤟";
        ramp-signal-4 = "󰤫";
      };
      "module/battery" = {
        type = "internal/battery";
        format-charging-background = "${colors.base}";
        format-discharging-background = "${colors.base}";
        format-full-background = "${colors.base}";
        battery = "BAT0";
        adapter = "AC";
        poll-interval = 1;
        format-charging = "%{F${colors.teal}}<ramp-capacity> <label-charging>%{F-}";
        format-discharging = "%{F${colors.pink}}<ramp-capacity> <label-discharging>%{F-}";
        format-full = "%{F${colors.green}}<ramp-capacity>%{F-}";
        ramp-capacity-0 = "";
        ramp-capacity-1 = "";
        ramp-capacity-2 = "";
        ramp-capacity-3 = "";
        ramp-capacity-4 = "";
      };
      "module/cpu" = {
        type = "internal/cpu";
        format-background = "${colors.base}";
        label = "%{F${colors.yellow}}󰻠 %percentage%%%{F-}";
      };
      "module/memory" = {
        type = "internal/memory";
        format-background = "${colors.base}";
        label = "%{F${colors.flamingo}}󰍛 %percentage_used%%%{F-}";
      };
      "module/rr" = {
        type = "custom/text";
        content = "%{T3}%{T-}";
        content-foreground = "${colors.base}";
      };
      "module/lr" = {
        type = "custom/text";
        content = "%{T3}%{T-}";
        content-foreground = "${colors.base}";
      };
      "module/sp" = {
        type = "custom/text";
        content = "  ";
        content-background = "${colors.base}";
      };
    };

    script = ''
      sleep 0.5 && polybar top &
    '';
  };
}
