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
}
