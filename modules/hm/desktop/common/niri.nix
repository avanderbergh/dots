_: {
  programs.niri.settings = {
    # Stylix integration from niri-flake owns cursor and border visuals.
    # Keep this module on programs.niri.settings and avoid programs.niri.config.
    input.keyboard.xkb.options = "compose:ralt,ctrl:nocaps";

    environment = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
      SDL_VIDEODRIVER = "wayland";
    };

    "screenshot-path" = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

    binds = {
      # Keep the upstream Niri key philosophy, with a few extra ergonomic aliases.
      "Mod+Shift+Slash".action."show-hotkey-overlay" = [];
      "Mod+F1".action."show-hotkey-overlay" = [];
      "Mod+Tab".action."toggle-overview" = [];

      "Mod+T".action.spawn = ["alacritty"];
      "Super+Return".action.spawn = ["alacritty"];
      "Mod+D".action.spawn = ["fuzzel"];
      "Super+Space".action.spawn = ["fuzzel"];
      "Super+Alt+L".action.spawn = ["swaylock"];

      "XF86AudioRaiseVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"];
      "XF86AudioLowerVolume".action.spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"];

      "Mod+Q".action."close-window" = [];

      "Mod+Left".action."focus-column-left" = [];
      "Mod+Down".action."focus-window-down" = [];
      "Mod+Up".action."focus-window-up" = [];
      "Mod+Right".action."focus-column-right" = [];
      "Mod+H".action."focus-column-left" = [];
      "Mod+J".action."focus-window-down" = [];
      "Mod+K".action."focus-window-up" = [];
      "Mod+L".action."focus-column-right" = [];

      "Mod+Ctrl+Left".action."move-column-left" = [];
      "Mod+Ctrl+Down".action."move-window-down" = [];
      "Mod+Ctrl+Up".action."move-window-up" = [];
      "Mod+Ctrl+Right".action."move-column-right" = [];
      "Mod+Ctrl+H".action."move-column-left" = [];
      "Mod+Ctrl+J".action."move-window-down" = [];
      "Mod+Ctrl+K".action."move-window-up" = [];
      "Mod+Ctrl+L".action."move-column-right" = [];

      "Mod+Home".action."focus-column-first" = [];
      "Mod+End".action."focus-column-last" = [];
      "Mod+Ctrl+Home".action."move-column-to-first" = [];
      "Mod+Ctrl+End".action."move-column-to-last" = [];

      "Mod+Shift+Left".action."focus-monitor-left" = [];
      "Mod+Shift+Down".action."focus-monitor-down" = [];
      "Mod+Shift+Up".action."focus-monitor-up" = [];
      "Mod+Shift+Right".action."focus-monitor-right" = [];
      "Mod+Shift+H".action."focus-monitor-left" = [];
      "Mod+Shift+J".action."focus-monitor-down" = [];
      "Mod+Shift+K".action."focus-monitor-up" = [];
      "Mod+Shift+L".action."focus-monitor-right" = [];

      "Mod+Shift+Ctrl+Left".action."move-column-to-monitor-left" = [];
      "Mod+Shift+Ctrl+Down".action."move-column-to-monitor-down" = [];
      "Mod+Shift+Ctrl+Up".action."move-column-to-monitor-up" = [];
      "Mod+Shift+Ctrl+Right".action."move-column-to-monitor-right" = [];
      "Mod+Shift+Ctrl+H".action."move-column-to-monitor-left" = [];
      "Mod+Shift+Ctrl+J".action."move-column-to-monitor-down" = [];
      "Mod+Shift+Ctrl+K".action."move-column-to-monitor-up" = [];
      "Mod+Shift+Ctrl+L".action."move-column-to-monitor-right" = [];

      # Dynamic workspace navigation and movement.
      "Mod+Page_Down".action."focus-workspace-down" = [];
      "Mod+Page_Up".action."focus-workspace-up" = [];
      "Mod+U".action."focus-workspace-down" = [];
      "Mod+I".action."focus-workspace-up" = [];
      "Mod+Ctrl+Page_Down".action."move-column-to-workspace-down" = [];
      "Mod+Ctrl+Page_Up".action."move-column-to-workspace-up" = [];
      "Mod+Ctrl+U".action."move-column-to-workspace-down" = [];
      "Mod+Ctrl+I".action."move-column-to-workspace-up" = [];
      "Mod+Shift+Page_Down".action."move-workspace-down" = [];
      "Mod+Shift+Page_Up".action."move-workspace-up" = [];
      "Mod+Shift+U".action."move-workspace-down" = [];
      "Mod+Shift+I".action."move-workspace-up" = [];

      "Mod+Comma".action."consume-window-into-column" = [];
      "Mod+Period".action."expel-window-from-column" = [];

      "Mod+R".action."switch-preset-column-width" = [];
      "Mod+F".action."maximize-column" = [];
      "Mod+Shift+F".action."fullscreen-window" = [];
      "Mod+C".action."center-column" = [];
      "Mod+Minus".action."set-column-width" = "-10%";
      "Mod+Equal".action."set-column-width" = "+10%";
      "Mod+Shift+Minus".action."set-window-height" = "-10%";
      "Mod+Shift+Equal".action."set-window-height" = "+10%";

      # Use grim/slurp/satty pipeline for screenshots.
      "Print".action.spawn = ["screenshot-region"];
      "Ctrl+Print".action.spawn = ["screenshot-screen"];
      "Alt+Print".action."screenshot-window" = [];

      "Mod+Shift+E".action.quit = {};
      "Mod+Shift+P".action."power-off-monitors" = [];
    };
  };
}
