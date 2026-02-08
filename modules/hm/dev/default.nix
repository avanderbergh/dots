{pkgs, ...}: {
  home.packages = with pkgs; [
    claude-code
    codex
    gemini-cli
    gh
    pi-coding-agent
  ];
}
