{colors, ...}: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 34;
      margin-top = 8;
      margin-left = 8;
      margin-right = 8;
      spacing = 8;
      "modules-left" = ["niri/workspaces" "niri/window"];
      "modules-center" = ["clock"];
      "modules-right" = ["niri/language" "cpu" "memory" "network" "pulseaudio" "tray"];

      "niri/workspaces" = {
        "disable-scroll" = false;
        "all-outputs" = true;
      };

      "niri/window" = {
        "separate-outputs" = true;
        "max-length" = 96;
      };

      clock = {
        format = " {:%H:%M}   {:%a %d %b}";
        "tooltip-format" = "{:%A, %d %B %Y %H:%M:%S}";
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
        font-family: "RecMonoLinear Nerd Font Propo";
        font-size: 16px;
      }

      window#waybar {
        background: ${colors.bgt};
        color: ${colors.text};
        border-radius: 16px;
      }

      #workspaces button {
        color: ${colors.subtext0};
        padding: 0 10px;
      }

      #workspaces button.active {
        color: ${colors.mauve};
      }

      #window,
      #clock,
      #cpu,
      #memory,
      #network,
      #pulseaudio,
      #language,
      #tray {
        background: ${colors.surface0};
        border-radius: 12px;
        margin: 5px 0;
        padding: 0 12px;
      }

      #window {
        color: ${colors.lavender};
      }
    '';
  };
}
