{...}: {
  stylix.targets.waybar = {
    addCss = true;
    enableLeftBackColors = true;
    enableCenterBackColors = true;
    enableRightBackColors = true;
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 34;
      margin-top = 0;
      margin-left = 0;
      margin-right = 0;
      spacing = 8;
      "modules-left" = ["niri/workspaces" "niri/window"];
      "modules-center" = ["clock"];
      "modules-right" = ["cpu" "memory" "network" "pulseaudio" "tray"];

      "niri/workspaces" = {
        "disable-scroll" = false;
        "all-outputs" = true;
      };

      "niri/window" = {
        "separate-outputs" = true;
        "max-length" = 24;
      };

      clock = {
        format = "{:%H:%M}";
      };

      cpu = {
        format = " {usage:2}%";
      };

      memory = {
        format = " {}%";
      };

      network = {
        format-wifi = "  {signalStrength}%";
        format-ethernet = "󰈀 {ifname}";
        format-disconnected = "󰖪 down";
      };

      pulseaudio = {
        format = " {volume}%";
        format-muted = " muted";
      };

      tray = {
        spacing = 10;
      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        min-height: 0;
      }

      window#waybar {
        border-radius: 0;
      }

      #workspaces button {
        padding: 0 10px;
      }

      #window,
      #clock,
      #cpu,
      #memory,
      #network,
      #pulseaudio,
      #language,
      #tray {
        border-radius: 12px;
        margin: 5px 0;
        padding: 0 12px;
      }
    '';
  };
}
