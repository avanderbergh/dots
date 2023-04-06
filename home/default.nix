{ config, pkgs, ... }:

{
  home.username = "avanderbergh";
  home.homeDirectory = "/home/avanderbergh";

  home.stateVersion = "22.11";

  programs = {
    alacritty.enable = true;
    fish.enable = true;
    home-manager.enable = true;
    starship.enable = true;
    vscode.enable = true;
  };
}