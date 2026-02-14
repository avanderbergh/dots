{pkgs, ...}: {
  home.packages = with pkgs; [
    claude-code
    codex
    devenv
    devcontainer
    gemini-cli
    gh
    pi-coding-agent
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
  };
}
