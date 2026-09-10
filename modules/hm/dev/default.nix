{config, ...}: let
  inherit (config.dots.packageSets) pkgs-master;
in {
  flake.modules.homeManager."profile-dev" = {pkgs, ...}: {
    home.packages = [
      pkgs.claude-code
      pkgs-master.codex
      pkgs.devenv
      pkgs.devcontainer
      pkgs.antigravity-cli
      pkgs.gh
      pkgs.opencode
      pkgs.pi-coding-agent
    ];

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };
  };
}
