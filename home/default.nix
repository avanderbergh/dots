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
            stateVersion = "23.05";

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
          };
        }
      ];
    };
  });
}
