{inputs, ...}: {
  flake.modules.nixos.desktop = {pkgs, ...}: {
    boot.plymouth.enable = true;

    programs = {
      niri = {
        enable = true;
        package = pkgs.niri;
        useNautilus = true;
      };

      # xdg-document-portal requires fusermount3 to hand selected files back to
      # portal clients such as Chrome.
      fuse.enable = true;

      gnupg.agent.pinentryPackage = pkgs.pinentry-gnome3;
    };

    services.upower.enable = true;

    services = {
      greetd = {
        enable = true;
        useTextGreeter = true;
        settings.default_session.command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --asterisks --cmd ${pkgs.niri}/bin/niri-session";
      };

      gnome = {
        gnome-keyring.enable = true;
        # Keep keyring secrets support, but avoid stealing SSH_AUTH_SOCK from gpg-agent.
        gcr-ssh-agent.enable = false;
      };
    };

    xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];

    environment.etc."nvidia/nvidia-application-profiles-rc.d/50-limit-free-buffer-pool-in-wayland-compositors.json".text = builtins.toJSON {
      rules = [
        {
          pattern = {
            feature = "procname";
            matches = "niri";
          };
          profile = "Limit Free Buffer Pool On Wayland Compositors";
        }
      ];
      profiles = [
        {
          name = "Limit Free Buffer Pool On Wayland Compositors";
          settings = [
            {
              key = "GLVidHeapReuseRatio";
              value = 0;
            }
          ];
        }
      ];
    };

    stylix = {
      enable = true;
      polarity = "dark";
      base16Scheme = "${inputs.stylix.inputs.tinted-schemes}/base16/catppuccin-mocha.yaml";
      cursor = {
        package = pkgs.catppuccin-cursors.mochaMauve;
        name = "catppuccin-mocha-mauve-cursors";
        size = 32;
      };
      fonts = {
        serif = {
          package = pkgs.recursive;
          name = "RecMonoCasual Nerd Font Propo";
        };

        sansSerif = {
          package = pkgs.recursive;
          name = "RecMonoLinear Nerd Font Propo";
        };

        monospace = {
          package = pkgs.recursive;
          name = "RecMonoLinear Nerd Font Mono";
        };

        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };

        sizes = {
          popups = 32;
        };
      };
      opacity = {
        popups = 0.9;
        terminal = 0.82;
      };
      image = inputs.self + /modules/hm/desktop/images/wallpaper.jpg;
    };

    environment.systemPackages = with pkgs; [
      dconf
      libnotify
      networkmanagerapplet
      xwayland-satellite
    ];
  };
}
