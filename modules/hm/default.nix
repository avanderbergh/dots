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
      expressvpn
      figma-agent
      figma-linux
      firefox
      google-chrome
      joshuto
      ledger-live-desktop
      obsidian
      pcmanfm
      pdfminer
      pdftk
      poppler_utils
      tesseract
      unzip
      xarchiver
      xclip
      xdotool
      xorg.xev
      xsel
    ];
  };

  programs = {
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
