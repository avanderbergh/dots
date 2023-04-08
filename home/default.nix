{ inputs, withSystem, ... }:
let
  inherit (inputs.home-manager.lib) homeManagerConfiguration;
in
{
  flake.homeConfigurations = withSystem "x86_64-linux" ({pkgs, ...} : {
    avanderbergh = homeManagerConfiguration {
      inherit pkgs;
      modules = [
        inputs.hyprland.homeManagerModules.default
        {
          home = {
            username = "avanderbergh";
            homeDirectory = "/home/avanderbergh";
            stateVersion = "22.11";

            file.".config" = {
              source = ./files/config;
              recursive = true;
            };
            
            packages = with pkgs; [
              alejandra
              brightnessctl
              btop
              cava
              obsidian
              wofi
            ];

            sessionVariables = {
              CLUTTER_BACKEND = "wayland";
              # DEFAULT_BROWSER = "${pkgs.firefox-nightly-bin}/bin/firefox";
              DIRENV_LOG_FORMAT = "";
              DISABLE_QT5_COMPAT = "0";
              EMACS_PATH_COPILOT = "${pkgs.fetchFromGitHub {
                owner = "zerolfx";
                repo = "copilot.el";
                rev = "05ffaddc5025d0d4e2424213f4989fc1a636ee31";
                hash = "sha256-K51HH8/ZkXXzmxCFqxsWn+o2hR3IPejkfQv7vgWBArQ=";
              }}";
              GBM_BACKEND = "nvidia-drm";
              GDK_BACKEND = "wayland";
              GDK_SCALE = "2";
              GLFW_IM_MODULE = "ibus";
              GPG_TTY = "$TTY";
              HOME_MANAGER_BACKUP_EXT = "bkp";
              LIBSEAT_BACKEND = "logind";
              LIBVA_DRIVER_NAME = "nvidia";
              NIXOS_OZONE_WL = "1";
              NIXPKGS_ALLOW_UNFREE = "1";
              QT_AUTO_SCREEN_SCALE_FACTOR = "1";
              QT_QPA_PLATFORM = "wayland;xcb";
              QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
              SDL_VIDEODRIVER = "wayland";
              WLR_BACKEND = "vulkan";
              WLR_DRM_NO_ATOMIC = "1";
              WLR_NO_HARDWARE_CURSORS = "1";
              WLR_RENDERER = "vulkan";
              XCURSOR_SIZE = "48";
              _JAVA_AWT_WM_NONREPARENTING = "1";
              __GL_GSYNC_ALLOWED = "0";
              __GL_VRR_ALLOWED = "0";
              __GLX_VENDOR_LIBRARY_NAME = "nvidia";
            };
          };
          
          programs = {
            alacritty.enable = true;
            exa = {
              enable = true;
              enableAliases = true;
            };
            fish.enable = true;
            fzf.enable = true;
            git = {
              enable = true;
              userEmail = "avanderbergh@gmail.com";
              userName = "Adriaan van der Bergh";
            };
            gpg.enable = true;
            home-manager.enable = true;
            lf.enable = true;
            mpv.enable = true;
            obs-studio.enable = true;
            starship.enable = true;
            tealdeer.enable = true;
            vscode = {
              enable = true;
              package = pkgs.vscode.fhs;
            };
            zathura.enable = true;
          };

          services = {
            gpg-agent = {
              enable = true;
              pinentryFlavor = "gnome3";
            };
          };

          wayland.windowManager.hyprland = {
            enable = true;
            extraConfig = ''
              $mod = SUPER

              bind = $mod, W, killactive,
              bind = $mod SHIFT, Q, exit,

              bind = $mod, left, movefocus, l
              bind = $mod, right, movefocus, r
              bind = $mod, up, movefocus, u
              bind = $mod, down, movefocus, d

              bind = $mod, S, submap, resize

              submap = resize
              binde = , right, resizeactive, 10 0
              binde = , left, resizeactive, -10 0
              binde = , up, resizeactive, 0 -10
              binde = , down, resizeactive, 0 10
              bind = , escape, submap, reset
              submap = reset

              # Programs
              bind = $mod, Return, exec, alacritty
              bindr = $mod, SUPER_L, exec, pkill wofi || wofi --show=drun
            '';
            nvidiaPatches = true;
            systemdIntegration = true;
          };
        }
      ];
    };
  });
}
