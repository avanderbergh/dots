{pkgs, ...}: {
  home = {
    username = "avanderbergh";
    homeDirectory = "/home/avanderbergh";
    stateVersion = "23.05";

    packages = with pkgs; [
      alejandra
      bitwig-studio
      brightnessctl
      btop
      calibre
      cava
      firefox
      ghq
      google-chrome
      joshuto
      ledger-live-desktop
      nodejs_20
      nodePackages.degit
      nodePackages.pnpm
      nodePackages.zx
      obsidian
      pcmanfm
      pdfminer
      pdftk
      poppler_utils
      tesseract
      xclip
      xdotool
      xorg.xev
      xsel
    ];

    sessionVariables = {
      GHQ_ROOT = "/home/avanderbergh/repos";
    };
  };

  programs = {
    git = {
      enable = true;
      userEmail = "avanderbergh@gmail.com";
      userName = "Adriaan van der Bergh";
      extraConfig = {
        core.editor = "code --wait";
        init.defaultBranch = "main";
      };
    };
    home-manager.enable = true;
    mpv.enable = true;
    obs-studio.enable = true;
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

  services.udiskie.enable = true;
}
