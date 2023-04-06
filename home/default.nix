{ config, pkgs, ... }:

{
  home.username = "avanderbergh";
  home.homeDirectory = "/home/avanderbergh";

  home.stateVersion = "22.11";

  programs.home-manager.enable = true;
  programs.vscode.enable = true;
}