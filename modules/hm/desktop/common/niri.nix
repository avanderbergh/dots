{
  flake.modules.homeManager."profile-desktop-niri" = {
    config,
    lib,
    pkgs,
    ...
  }: let
    colors = config.lib.stylix.colors.withHashtag;
    translucent = color: alpha: "${color}${alpha}";
  in {
    wayland.windowManager.niri = {
      enable = true;
      package = pkgs.niri;

      # NixOS owns the session units, portal packages, and XWayland package.
      portalPackage = null;
      systemd.enable = false;
      xwaylandSatellitePackage = null;

      settings = {
        # Keep the Catppuccin surfaces calm while using its brighter accents for
        # focus and movement. The colors stay coupled to the shared Stylix palette.
        blur = {
          passes = 2;
          offset = 3.0;
          noise = 0.02;
          saturation = 1.1;
        };

        input = {
          keyboard.xkb.options = "compose:ralt,ctrl:nocaps";
          touchpad = {
            tap = {};
            dwt = {};
            "natural-scroll" = {};
          };
        };

        environment = {
          NIXOS_OZONE_WL = "1";
          MOZ_ENABLE_WAYLAND = "1";
          QT_QPA_PLATFORM = "wayland;xcb";
          SDL_VIDEODRIVER = "wayland";
        };

        "screenshot-path" = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

        "hotkey-overlay"."skip-at-startup" = {};

        overview = {
          "backdrop-color" = colors.base00;
          zoom = 0.52;
          "workspace-shadow" = {
            softness = 40;
            spread = 8;
            offset._props = {
              x = 0;
              y = 10;
            };
            color = translucent colors.base00 "a6";
          };
        };

        "recent-windows" = {
          "debounce-ms" = 650;
          "open-delay-ms" = 120;
          highlight = {
            "active-color" = translucent colors.base0E "59";
            "urgent-color" = translucent colors.base08 "73";
            padding = 20;
            "corner-radius" = 18;
          };
          previews = {
            "max-height" = 560;
            "max-scale" = 0.62;
          };
        };

        animations = {
          "workspace-switch".spring._props = {
            "damping-ratio" = 1.0;
            stiffness = 850;
            epsilon = 0.0001;
          };
          "horizontal-view-movement".spring._props = {
            "damping-ratio" = 0.96;
            stiffness = 700;
            epsilon = 0.0001;
          };
          "window-movement".spring._props = {
            "damping-ratio" = 0.94;
            stiffness = 750;
            epsilon = 0.0001;
          };
          "window-resize".spring._props = {
            "damping-ratio" = 1.0;
            stiffness = 800;
            epsilon = 0.0001;
          };
          "window-open" = {
            "duration-ms" = 180;
            curve = "ease-out-expo";
          };
          "window-close" = {
            "duration-ms" = 160;
            curve = "ease-out-cubic";
          };
          "overview-open-close".spring._props = {
            "damping-ratio" = 1.0;
            stiffness = 500;
            epsilon = 0.0001;
          };
        };

        # A roomier rhythm makes the window geometry and wallpaper visible without
        # wasting the ultrawide display.
        layout = {
          gaps = 12;
          "center-focused-column" = "on-overflow";
          "always-center-single-column" = {};

          "preset-column-widths"._children = [
            {proportion = 0.33333;}
            {proportion = 0.5;}
            {proportion = 0.66667;}
          ];
          "default-column-width".proportion = 0.5;
          "preset-window-heights"._children = [
            {proportion = 0.33333;}
            {proportion = 0.5;}
            {proportion = 0.66667;}
          ];

          "focus-ring" = {
            width = 3;
            "active-gradient"._props = {
              from = colors.base0E;
              to = colors.base0D;
              angle = 135;
              "relative-to" = "workspace-view";
            };
            "inactive-color" = translucent colors.base03 "b3";
            "urgent-color" = colors.base08;
          };

          border.off = {};

          shadow = {
            on = {};
            softness = 28;
            spread = 4;
            offset._props = {
              x = 0;
              y = 6;
            };
            color = translucent colors.base00 "8c";
            "inactive-color" = translucent colors.base00 "59";
          };

          "tab-indicator" = {
            "hide-when-single-tab" = {};
            "place-within-column" = {};
            gap = 6;
            width = 6;
            length._props."total-proportion" = 0.55;
            position = "left";
            "gaps-between-tabs" = 4;
            "corner-radius" = 6;
            "active-color" = colors.base0E;
            "inactive-color" = translucent colors.base03 "cc";
            "urgent-color" = colors.base08;
          };

          "insert-hint".gradient._props = {
            from = translucent colors.base0E "b3";
            to = translucent colors.base0D "b3";
            angle = 135;
          };
        };

        cursor = lib.optionalAttrs (config.stylix.cursor != null) {
          "xcursor-theme" = config.stylix.cursor.name;
          "xcursor-size" = config.stylix.cursor.size;
        };

        binds = {
          # Keep the upstream Niri key philosophy, with a few extra ergonomic aliases.
          "Mod+Shift+Slash"."show-hotkey-overlay" = {};
          "Mod+F1"."show-hotkey-overlay" = {};
          "Mod+O"."toggle-overview" = {};

          "Mod+T".spawn = ["alacritty"];
          "Super+Return".spawn = ["alacritty"];
          "Mod+D".spawn = ["noctalia" "msg" "panel-toggle" "launcher"];
          "Super+Space".spawn = ["noctalia" "msg" "panel-toggle" "launcher"];
          "Super+Alt+L".spawn = ["noctalia" "msg" "session" "lock"];
          "Mod+Shift+C".spawn = ["noctalia" "msg" "caffeine-toggle"];

          "XF86AudioRaiseVolume" = {
            _props."allow-when-locked" = true;
            spawn = ["noctalia" "msg" "volume-up"];
          };
          "XF86AudioLowerVolume" = {
            _props."allow-when-locked" = true;
            spawn = ["noctalia" "msg" "volume-down"];
          };
          "XF86AudioMute" = {
            _props."allow-when-locked" = true;
            spawn = ["noctalia" "msg" "volume-mute"];
          };
          "XF86AudioMicMute" = {
            _props."allow-when-locked" = true;
            spawn = ["noctalia" "msg" "mic-mute"];
          };
          "XF86MonBrightnessUp" = {
            _props."allow-when-locked" = true;
            spawn = ["noctalia" "msg" "brightness-up"];
          };
          "XF86MonBrightnessDown" = {
            _props."allow-when-locked" = true;
            spawn = ["noctalia" "msg" "brightness-down"];
          };
          "XF86AudioPlay" = {
            _props."allow-when-locked" = true;
            spawn = ["noctalia" "msg" "media" "toggle"];
          };
          "XF86AudioNext" = {
            _props."allow-when-locked" = true;
            spawn = ["noctalia" "msg" "media" "next"];
          };
          "XF86AudioPrev" = {
            _props."allow-when-locked" = true;
            spawn = ["noctalia" "msg" "media" "previous"];
          };

          "Mod+Q"."close-window" = {};

          "Mod+Left"."focus-column-left" = {};
          "Mod+Down"."focus-window-down" = {};
          "Mod+Up"."focus-window-up" = {};
          "Mod+Right"."focus-column-right" = {};
          "Mod+H"."focus-column-left" = {};
          "Mod+J"."focus-window-down" = {};
          "Mod+K"."focus-window-up" = {};
          "Mod+L"."focus-column-right" = {};

          "Mod+Ctrl+Left"."move-column-left" = {};
          "Mod+Ctrl+Down"."move-window-down" = {};
          "Mod+Ctrl+Up"."move-window-up" = {};
          "Mod+Ctrl+Right"."move-column-right" = {};
          "Mod+Ctrl+H"."move-column-left" = {};
          "Mod+Ctrl+J"."move-window-down" = {};
          "Mod+Ctrl+K"."move-window-up" = {};
          "Mod+Ctrl+L"."move-column-right" = {};

          "Mod+Home"."focus-column-first" = {};
          "Mod+End"."focus-column-last" = {};
          "Mod+Ctrl+Home"."move-column-to-first" = {};
          "Mod+Ctrl+End"."move-column-to-last" = {};

          "Mod+Shift+Left"."focus-monitor-left" = {};
          "Mod+Shift+Down"."focus-monitor-down" = {};
          "Mod+Shift+Up"."focus-monitor-up" = {};
          "Mod+Shift+Right"."focus-monitor-right" = {};
          "Mod+Shift+H"."focus-monitor-left" = {};
          "Mod+Shift+J"."focus-monitor-down" = {};
          "Mod+Shift+K"."focus-monitor-up" = {};
          "Mod+Shift+L"."focus-monitor-right" = {};

          "Mod+Shift+Ctrl+Left"."move-column-to-monitor-left" = {};
          "Mod+Shift+Ctrl+Down"."move-column-to-monitor-down" = {};
          "Mod+Shift+Ctrl+Up"."move-column-to-monitor-up" = {};
          "Mod+Shift+Ctrl+Right"."move-column-to-monitor-right" = {};
          "Mod+Shift+Ctrl+H"."move-column-to-monitor-left" = {};
          "Mod+Shift+Ctrl+J"."move-column-to-monitor-down" = {};
          "Mod+Shift+Ctrl+K"."move-column-to-monitor-up" = {};
          "Mod+Shift+Ctrl+L"."move-column-to-monitor-right" = {};

          # Dynamic workspace navigation and movement.
          "Mod+Page_Down"."focus-workspace-down" = {};
          "Mod+Page_Up"."focus-workspace-up" = {};
          "Mod+U"."focus-workspace-down" = {};
          "Mod+I"."focus-workspace-up" = {};
          "Mod+Ctrl+Page_Down"."move-column-to-workspace-down" = {};
          "Mod+Ctrl+Page_Up"."move-column-to-workspace-up" = {};
          "Mod+Ctrl+U"."move-column-to-workspace-down" = {};
          "Mod+Ctrl+I"."move-column-to-workspace-up" = {};
          "Mod+Shift+Page_Down"."move-workspace-down" = {};
          "Mod+Shift+Page_Up"."move-workspace-up" = {};
          "Mod+Shift+U"."move-workspace-down" = {};
          "Mod+Shift+I"."move-workspace-up" = {};

          "Mod+Comma"."consume-window-into-column" = {};
          "Mod+Period"."expel-window-from-column" = {};

          "Mod+R"."switch-preset-column-width" = {};
          "Mod+Shift+R"."switch-preset-column-width-back" = {};
          "Mod+Ctrl+R"."switch-preset-window-height" = {};
          "Mod+Ctrl+Shift+R"."switch-preset-window-height-back" = {};
          "Mod+F"."maximize-column" = {};
          "Mod+Shift+F"."fullscreen-window" = {};
          "Mod+C"."center-column" = {};
          "Mod+W"."toggle-column-tabbed-display" = {};
          "Mod+V"."toggle-window-floating" = {};
          "Mod+Shift+V"."switch-focus-between-floating-and-tiling" = {};
          "Mod+Minus"."set-column-width" = "-10%";
          "Mod+Equal"."set-column-width" = "+10%";
          "Mod+Shift+Minus"."set-window-height" = "-10%";
          "Mod+Shift+Equal"."set-window-height" = "+10%";

          # Use grim/slurp/satty pipeline for screenshots.
          "Print".spawn = ["screenshot-region"];
          "Ctrl+Print".spawn = ["screenshot-screen"];
          "Alt+Print"."screenshot-window" = {};

          "Mod+Shift+E".quit = {};
          "Mod+Shift+P"."power-off-monitors" = {};
        };

        debug."honor-xdg-activation-with-invalid-serial" = {};

        # Repeated rule sections live in _children so Home Manager emits distinct
        # KDL nodes in a stable order.
        _children = [
          {
            "window-rule" = {
              "geometry-corner-radius" = 16;
              "clip-to-geometry" = true;
              "background-effect" = {
                blur = true;
                xray = false;
              };
            };
          }
          {
            "window-rule" = {
              match._props."app-id" = "^dev[.]noctalia[.]Noctalia$";
              "open-floating" = true;
              "default-column-width".fixed = 1080;
              "default-window-height".fixed = 920;
            };
          }
          {
            "window-rule" = {
              match._props = {
                "app-id" = "firefox$";
                title = "^Picture-in-Picture$";
              };
              "open-floating" = true;
              "default-column-width".fixed = 480;
              "default-window-height".fixed = 270;
            };
          }
          {
            "layer-rule" = {
              match._props.namespace = "^noctalia-backdrop";
              "place-within-backdrop" = true;
            };
          }
          {
            "layer-rule" = {
              match._props.namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd)$";
              "background-effect".xray = false;
            };
          }
          {
            "layer-rule" = {
              match._props.namespace = "^noctalia-window-switcher$";
              "background-effect" = {
                blur = true;
                xray = false;
              };
            };
          }
        ];
      };
    };
  };
}
