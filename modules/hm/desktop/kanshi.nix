{
  flake.modules.homeManager."profile-desktop-kanshi" = {
    config,
    lib,
    ...
  }: let
    homeMonitor = "Samsung Electric Company C49RG9x H1AK500000";
    homeMode = "5120x1440";
    homeScale = 4.0 / 3.0;

    # Niri replaces its live output configuration when kanshi applies a
    # profile. Restore the mode for the disconnected Samsung before hotplug.
    restoreHomeMode = lib.escapeShellArgs [
      (lib.getExe config.wayland.windowManager.niri.package)
      "msg"
      "output"
      homeMonitor
      "mode"
      homeMode
    ];
  in {
    # Initialize the DRM surface at the native mode so Niri can retry buffer
    # allocation with a compatible modifier before the kanshi profile applies.
    wayland.windowManager.niri.settings._children = [
      {
        output = {
          _args = [homeMonitor];
          mode = homeMode;
          scale = homeScale;
        };
      }
    ];

    services.kanshi = {
      enable = true;
      # Match external displays by EDID so the profiles survive USB-C port
      # changes and DRM connector renumbering.
      settings = [
        {
          profile = {
            name = "mobile";
            exec = restoreHomeMode;
            outputs = [
              {
                criteria = "eDP-1";
                status = "enable";
                mode = "3840x2400";
                position = "0,0";
                scale = 2.0;
              }
            ];
          };
        }
        {
          profile = {
            name = "home";
            outputs = [
              {
                criteria = homeMonitor;
                status = "enable";
                mode = homeMode;
                position = "0,0";
                scale = homeScale;
              }
              {
                criteria = "eDP-1";
                status = "enable";
                mode = "3840x2400";
                position = "3840,0";
                scale = 2.625;
              }
            ];
          };
        }
        {
          profile = {
            name = "portable_monitor";
            exec = restoreHomeMode;
            outputs = [
              {
                criteria = "eDP-1";
                status = "enable";
                mode = "3840x2400";
                position = "0,0";
                scale = 2.0;
              }
              {
                criteria = "* M173F01 *";
                status = "enable";
                mode = "1920x1080";
                position = "1920,0";
                scale = 2.0;
              }
            ];
          };
        }
      ];
    };
  };
}
