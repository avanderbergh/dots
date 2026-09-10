{
  flake.modules.nixos.noctalia-greeter = {
    config,
    pkgs,
    ...
  }: let
    owner = config.local.users.ownerName;
    desktop = config.home-manager.users.${owner};
    noctalia = desktop.programs.noctalia;
    shell = noctalia.settings.shell;
    theme = noctalia.settings.theme;
    palette = noctalia.customPalettes.${theme.custom_palette}.${theme.mode};
    logo = pkgs.replaceVars ./_assets/noctalia-greeter/soot-sprite.svg {
      soot = palette.mSurface;
      outline = palette.mSecondary;
      eyes = palette.mOnSurface;
      sparkle = palette.mTertiary;
      star = config.lib.stylix.colors.withHashtag.base0A;
    };
    assets = pkgs.symlinkJoin {
      name = "noctalia-greeter-ghibli-assets";
      paths = ["${config.services.displayManager.noctalia-greeter.package}/share/noctalia-greeter/assets"];
      postBuild = ''
        ln -sfn ${logo} "$out/noctalia.svg"
      '';
    };
  in {
    services.displayManager.noctalia-greeter = {
      enable = true;

      cursorTheme = {
        inherit (config.stylix.cursor) package name;
      };

      settings = {
        # Use the desktop entry's Name, not its filename or launch command.
        session.default = "Niri";
        user.default = owner;
        idle.timeout = 300;

        cursor.size = config.stylix.cursor.size;
        keyboard = {
          inherit (config.services.xserver.xkb) layout variant;
          inherit (desktop.wayland.windowManager.niri.settings.input.keyboard.xkb) options;
        };

        appearance = {
          scheme = "Synced";
          theme_mode = theme.mode;
          inherit (shell) font_family corner_radius_scale;
          password_style = "default";

          # Read Noctalia's actual Stylix-generated color roles so the login
          # screen follows desktop theme changes without a second palette.
          palette = {
            primary = palette.mPrimary;
            on_primary = palette.mOnPrimary;
            secondary = palette.mSecondary;
            on_secondary = palette.mOnSecondary;
            tertiary = palette.mTertiary;
            on_tertiary = palette.mOnTertiary;
            error = palette.mError;
            on_error = palette.mOnError;
            surface = palette.mSurface;
            on_surface = palette.mOnSurface;
            surface_variant = palette.mSurfaceVariant;
            on_surface_variant = palette.mOnSurfaceVariant;
            outline = palette.mOutline;
            shadow = palette.mShadow;
            hover = palette.mHover;
            on_hover = palette.mOnHover;
          };

          # A copy from the desktop's Ghibli collection remains available
          # before login, independently of the home directory and slideshow.
          wallpaper = {
            path = toString ./_assets/noctalia-greeter/howls-moving-castle.jpg;
            inherit (noctalia.settings.wallpaper) fill_mode;
            fill_color = palette.mSurface;
          };
        };
      };
    };

    # NixOS collects session entries in a separate store path. Make discovery
    # explicit for the greeter's otherwise minimal service environment.
    systemd.services.greetd.environment = {
      XDG_DATA_DIRS = "${config.services.displayManager.sessionData.desktops}/share";
      # Keep the packaged fonts/icons and replace only the bottom brand mark.
      NOCTALIA_GREETER_ASSETS_DIR = toString assets;
    };

    environment.persistence."/persist".directories = [
      {
        directory = "/var/lib/noctalia-greeter";
        user = config.services.greetd.settings.default_session.user;
        group = "greeter";
        mode = "0750";
      }
      "/var/lib/AccountsService"
    ];
  };
}
