{ inputs, pkgs, ... }:

{

  imports = [ ./modules/hyprland.nix ];

  home = {
    username = "avanderbergh";
    homeDirectory = "/home/avanderbergh";
    stateVersion = "23.05";

    file.".config" = {
      source = ./files/config;
      recursive = true;
    };

    packages = with pkgs; [
      alejandra
      brightnessctl
      btop
      cava
      firefox
      google-chrome
      obsidian
    ];
  };

  programs = {
    alacritty.enable = true;
    exa = {
      enable = true;
      enableAliases = true;
    };
    fish.enable = true;
    fzf.enable = true;
    git = {
      enable = true;
      userEmail = "avanderbergh@gmail.com";
      userName = "Adriaan van der Bergh";
    };
    home-manager.enable = true;
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

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Pink-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "pink" ];
        variant = "mocha";
      };
    };
  };

  qt = {
    enable = true;
    platFormTheme = "gtk";
  }

}
