{config, ...}: let
  inherit (config.dots.packageSets) pkgs-stable;
in {
  flake.modules.homeManager."profile-desktop-obs" = {pkgs, ...}: {
    programs.obs-studio = {
      enable = true;
      plugins = with pkgs-stable; [
        obs-studio-plugins.droidcam-obs
        obs-studio-plugins.obs-websocket
        obs-studio-plugins.obs-shaderfilter
      ];
    };

    home.packages = with pkgs; [
      asciicam
      obs-cli
    ];
  };
}
