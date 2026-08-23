{
  flake.modules.homeManager."profile-dev" = {pkgs, ...}: {
    home.packages = with pkgs; [
      claude-code
      codex
      devenv
      devcontainer
      antigravity-cli
      gh
      opencode
      pi-coding-agent
    ];

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };
  };
}
