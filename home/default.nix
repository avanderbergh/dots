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
          home.username = "avanderbergh";
          home.homeDirectory = "/home/avanderbergh";

          home.stateVersion = "22.11";
          
          programs = {
            alacritty.enable = true;
            fish.enable = true;
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

          home.packages = with pkgs; [
            wofi
          ];

          home.file.".config" = {
            source = ./files/config;
            recursive = true;
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

              bind = #mod, S, submap, resize

              submap = resize

              bind = , right, resizeactive, 10 0
              bind = , left, resizeactive, -10 0
              bind = , up, resizeactive, 0 -10
              bind = , down, resizeactive, 0 10
              bind = , escape, submap, reset
              
              submap = reset

              # Programs
              bind = $mod, Return, exec, alacritty
              bindr = $mod, SUPER_L, exec, pkill wofi || wofi --show=drun
            '';
            # xwayland.hidpi = true;
          };
        }
      ];
    };
  });
}
