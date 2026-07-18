{inputs, ...}: {
  flake.modules.homeManager."profile-desktop-noctalia" = {
    imports = [inputs.noctalia.homeModules.default];

    programs.noctalia = {
      enable = true;
      systemd.enable = true;
      validateConfig = true;

      settings = {
        accessibility.ui_scale = 1.0;

        shell = {
          corner_radius_scale = 1.15;
          time_format = "{:%H:%M}";
          date_format = "%A, %d %B %Y";
          setup_wizard_enabled = false;
          settings_show_advanced = true;
          middle_click_opens_widget_settings = true;
          clipboard_enabled = true;
          clipboard_history_max_entries = 250;
          app_icon_colorize = true;
          app_icon_color = "on_surface";

          animation = {
            enabled = true;
            speed = 1.0;
          };

          shadow = {
            direction = "right";
            alpha = 0.45;
          };

          panel = {
            transparency_mode = "glass";
            borders = true;
            shadow = true;
            launcher_placement = "floating";
            launcher_position = "center";
            clipboard_placement = "floating";
            clipboard_position = "center";
            control_center_placement = "attached";
            wallpaper_placement = "attached";
            session_placement = "attached";
            open_near_click_control_center = true;
            open_near_click_wallpaper = true;
            open_near_click_session = true;
          };
        };

        theme = {
          pure_black_dark = false;

          templates = {
            # Stylix owns application configuration; Noctalia owns shell colors.
            enable_builtin_templates = false;
            enable_community_templates = false;
          };
        };

        wallpaper = {
          enabled = true;
          fill_mode = "crop";
          transition = ["fade" "wipe" "zoom"];
          transition_duration = 1200;
          directory = "~/Pictures/Wallpapers";

          automation = {
            enabled = true;
            interval_seconds = 3600;
            order = "random";
            recursive = true;
          };
        };

        notification = {
          enable_daemon = true;
          show_app_name = true;
          show_actions = true;
          layer = "overlay";
          offset_x = 18;
          offset_y = 18;
        };

        osd = {
          position = "top_right";
          position_vertical = "center_right";
          orientation = "vertical";
          offset_x = 18;
          offset_y = 18;
        };

        lockscreen = {
          enabled = true;
          blurred_desktop = true;
          blur_intensity = 0.6;
          tint_intensity = 0.35;
        };

        idle = {
          pre_action_fade_seconds = 2.0;
          behavior = {
            lock = {
              enabled = true;
              timeout = 300;
              action = "lock";
            };
            "screen-off" = {
              enabled = true;
              timeout = 600;
              action = "screen_off";
            };
            "lock-and-suspend" = {
              enabled = true;
              timeout = 1200;
              action = "lock_and_suspend";
            };
          };
        };

        system.monitor = {
          enabled = true;
          cpu_poll_seconds = 2.0;
          gpu_poll_seconds = 5.0;
          memory_poll_seconds = 2.0;
          network_poll_seconds = 3.0;
          disk_poll_seconds = 10.0;
        };

        weather = {
          enabled = true;
          refresh_minutes = 30;
          unit = "celsius";
          effects = true;
        };

        location.auto_locate = true;

        bar = {
          order = ["main"];

          main = {
            enabled = true;
            position = "left";
            layer = "top";
            reserve_space = true;
            auto_hide = false;
            thickness = 50;
            background_opacity = 0.94;
            border = "outline";
            border_width = 1.0;
            shadow = true;
            contact_shadow = true;
            panel_overlap = 1;
            radius = 14;
            margin_ends = 2;
            margin_edge = 2;
            padding = 6;
            widget_spacing = 4;
            hover_highlight = true;
            scale = 1.0;
            font_family = "RecMonoLinear Nerd Font Mono";
            font_weight = "bold";

            # Catppuccin uses surfaces for grouping and accents for hierarchy.
            # Avoid wrapping every icon in its own visually noisy capsule.
            capsule = false;
            capsule_fill = "surface_variant";
            capsule_foreground = "on_surface";
            capsule_border = "";
            capsule_thickness = 0.72;
            capsule_radius = 12.0;
            capsule_padding = 5;
            capsule_opacity = 0.88;

            start = [
              "launcher"
              "workspaces"
              "taskbar"
            ];
            center = [
              "clock"
              "weather"
            ];
            end = [
              "privacy"
              "media"
              "tray"
              "group:essentials"
              "notifications"
              "control-center"
              "session"
            ];

            capsule_group = [
              {
                id = "essentials";
                members = [
                  "network"
                  "output_volume"
                  "battery"
                  "caffeine"
                ];
                enabled = true;
                fill = "surface_variant";
                foreground = "on_surface_variant";
                border = "";
                padding = 4;
                radius = 12.0;
                opacity = 0.82;
              }
            ];

            dead_zone.command = "noctalia msg panel-toggle launcher";

            monitor.ultrawide = {
              match = "DP-1";
              thickness = 54;
            };
          };
        };

        widget = {
          launcher = {
            glyph = "menu-2";
            capsule = true;
            capsule_fill = "primary";
            capsule_foreground = "on_primary";
            capsule_padding = 6;
            capsule_opacity = 1.0;
          };

          workspaces = {
            display = "none";
            minimal = false;
            labels_only_when_occupied = true;
            focused_output_only = true;
            active_pill_size = 1.75;
            inactive_pill_size = 0.72;
            focused_color = "primary";
            occupied_color = "secondary";
            empty_color = "surface";
            capsule = false;
          };

          taskbar = {
            only_active_workspace = true;
            show_all_outputs = false;
            group_by_workspace = false;
            group_single_icon_per_app = true;
            show_active_indicator = true;
            active_opacity = 1.0;
            inactive_opacity = 0.62;
            capsule = false;
          };

          clock = {
            format = "{:%H:%M}";
            vertical_format = "{:%H\n%M}";
            tooltip_format = "{:%A, %d %B %Y}";
            capsule = true;
            capsule_fill = "secondary";
            capsule_foreground = "on_secondary";
            capsule_padding = 7;
            capsule_opacity = 1.0;
          };

          media = {
            album_art_only = true;
            art_size = 24;
            hide_when_no_media = true;
          };

          privacy = {
            hide_inactive = true;
            icon_spacing = 6;
            active_color = "error";
          };

          tray = {
            drawer = true;
            drawer_columns = 3;
            drawer_item_size = 22;
          };

          weather = {
            show_condition = false;
            show_temperature = true;
            capsule = true;
            capsule_fill = "tertiary";
            capsule_foreground = "on_tertiary";
            capsule_padding = 5;
            capsule_opacity = 0.92;
          };

          cpu = {
            display = "gauge";
            show_label = true;
            highlight_color = "error";
          };

          ram = {
            stat = "ram_pct";
            display = "gauge";
            show_label = true;
            highlight_color = "secondary";
          };

          temp = {
            display = "text";
            highlight_color = "error";
          };

          network = {
            show_label = false;
            icon_color = "primary";
          };
          bluetooth.show_label = false;

          output_volume = {
            show_label = false;
            scroll_step = 5;
            mute_color = "error";
            icon_color = "secondary";
          };

          brightness = {
            show_label = true;
            scroll_step = 5;
          };

          battery = {
            display_mode = "glyph";
            show_label = false;
            warning_color = "error";
            icon_color = "tertiary";
          };

          caffeine = {
            icon_color = "#FAB387";
          };

          notifications = {
            hide_when_no_unread = true;
            icon_color = "#F9E2AF";
          };

          control-center.icon_color = "#B4BEFE";
          session.icon_color = "error";
        };

        dock.enabled = false;

        battery.warning_threshold = 20;

        control_center.shortcuts = [
          {type = "wifi";}
          {type = "bluetooth";}
          {type = "notification";}
          {type = "wallpaper";}
          {type = "screen_recorder";}
          {type = "session";}
        ];
      };
    };
  };
}
