{pkgs, ...}: {
  home = {
    username = "avanderbergh";
    homeDirectory = "/home/avanderbergh";
    stateVersion = "23.05";

    packages = with pkgs; [
      alejandra
      bitwig-studio
      brightnessctl
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
      telegram-desktop
      tesseract
      unzip
      wpsoffice
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
      # package = (pkgs.vscode.override {isInsiders = true;}).overrideAttrs (oldAttrs: rec {
      #   src = builtins.fetchTarball {
      #     url = "https://update.code.visualstudio.com/latest/linux-x64/insider";
      #     sha256 = "1cgrn4n6y348x0c7ndmn5vssvpj1sdk27bp91cayr27fb59lgmv9";
      #   };
      #   version = "latest";
      # });
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
