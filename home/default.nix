{ inputs, withSystem, ... }:
let
  inherit (inputs.home-manager.lib) homeManagerConfiguration;
in
{
  flake.homeConfigurations = withSystem "x86_64-linux" ({pkgs, ...} : {
    avanderbergh = homeManagerConfiguration {
      inherit pkgs;

      modules = [
        {
          home.username = "avanderbergh";
          home.homeDirectory = "/home/avanderbergh";

          home.stateVersion = "22.11";

          programs = {
            alacritty.enable = true;
            fish.enable = true;
            home-manager.enable = true;
            hyprland.enable = true;
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
        }
      ];
    };
  });
}
