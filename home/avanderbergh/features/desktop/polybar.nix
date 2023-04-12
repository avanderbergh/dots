{
  services.polybar = {
    enable = true;
    config = {
      "bar/top" = {
        monitor = "eDP-1";
        width = "100%";
        height = "3%";
        dpi = 0;
        radius = 0;
        modules-left = "bspwm";
        modules-center = "date";
        scroll-up = "#bspwm.prev";
        scroll-down = "#bspwm.next";
        tray-position = "right";
        font-0 = "Victor Mono:size=10";
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
}
