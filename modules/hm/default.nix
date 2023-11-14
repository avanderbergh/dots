{pkgs, ...}: {
  home = {
    username = "avanderbergh";
    homeDirectory = "/home/avanderbergh";
    stateVersion = "23.05";

    packages = with pkgs; [
      alejandra
      bitwig-studio
      blender
      brightnessctl
      calibre
      cava
      cura
      davinci-resolve
      discord-canary
      esptool
      expressvpn
      figma-agent
      # Package ‘figma-linux-0.10.0’ in /nix/store/kcmipm57ph9bpzz8bs80iiijiwbyzwy3-source/pkgs/applications/graphics/figma-linux/default.nix:72 is marked as insecure, refusing to evaluate.
      # figma-linux
      firefox
      google-chrome
      inav-configurator
      joshuto
      ledger-live-desktop
      libgen-cli
      libresprite
      logseq
      nsxiv
      obsidian
      openscad
      pcmanfm
      pdfminer
      pdftk
      pgcli
      poppler_utils
      prusa-slicer
      slack
      super-slicer
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
    pandoc.enable = true;
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
