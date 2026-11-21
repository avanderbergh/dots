{config, ...}: let
  inherit (config.dots.packageSets) llm-agents;
in {
  flake.modules.homeManager."profile-dev" = {pkgs, ...}: {
    home.packages = [
      llm-agents.antigravity-cli
      llm-agents.claude-code
      llm-agents.codex
      llm-agents.opencode2
      llm-agents.pi
      pkgs.devcontainer
      pkgs.devenv
      pkgs.gh
      pkgs.tuios
    ];

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };

    programs.herdr = {
      enable = true;
      package = llm-agents.herdr;
      settings = {
        terminal.default_shell = "fish";
        theme.name = "catppuccin";
      };
    };
  };
}
