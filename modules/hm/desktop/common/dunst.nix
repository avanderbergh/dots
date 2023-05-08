{colors, ...}: {
  services.dunst = {
    enable = true;
    settings = {
      global = {
        font = "Victor Mono 14";
        frame_color = colors.blue;
        origin = "top-center";
        separator_color = colors.blue;
        transparency = 20;
      };
      urgency_low = {
        background = colors.base;
        foreground = colors.text;
      };
      urgency_normal = {
        background = colors.base;
        foreground = colors.text;
      };
      urgency_critical = {
        background = colors.base;
        foreground = colors.text;
        frame_color = colors.peach;
      };
    };
  };
}
