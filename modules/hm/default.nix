{pkgs, ...}: {
  home = {
    username = "avanderbergh";
    homeDirectory = "/home/avanderbergh";
    stateVersion = "23.05";

    packages = with pkgs; [
      alejandra
      brightnessctl
      btop
      calibre
      cava
      firefox
      google-chrome
      nodejs_20
      nodePackages.degit
      nodePackages.pnpm
      nodePackages.zx
      obsidian
      pdfminer
      pdftk
      poppler_utils
      tabula
      tabula-java
      tesseract
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

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };
}
