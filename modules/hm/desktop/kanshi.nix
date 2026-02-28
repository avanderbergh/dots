_: {
  services.kanshi = {
    enable = true;
    # Output names are intentionally aligned with the old autorandr setup.
    # If names differ on first boot, update with: niri msg outputs
    settings = [
      {
        profile = {
          name = "mobile";
          outputs = [
            {
              criteria = "eDP-1-1";
              status = "enable";
              mode = "3840x2400";
              position = "0,0";
              scale = 2.0;
            }
            {
              criteria = "DP-1-1";
              status = "disable";
            }
            {
              criteria = "DP-1-3";
              status = "disable";
            }
          ];
        };
      }
      {
        profile = {
          name = "home";
          outputs = [
            {
              criteria = "DP-1-1";
              status = "enable";
              mode = "5120x1440";
              position = "0,0";
              scale = 1.0;
            }
            {
              criteria = "eDP-1-1";
              status = "enable";
              mode = "1920x1200";
              position = "5120,0";
              scale = 1.0;
            }
          ];
        };
      }
      {
        profile = {
          name = "portable_monitor";
          outputs = [
            {
              criteria = "eDP-1-1";
              status = "enable";
              mode = "3840x2400";
              position = "0,0";
              scale = 2.0;
            }
            {
              criteria = "DP-1-3";
              status = "enable";
              mode = "1920x1080";
              position = "3840,0";
              scale = 2.0;
            }
          ];
        };
      }
    ];
  };
}
