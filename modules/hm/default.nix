{
  pkgs,
  pkgs-stable,
  ...
}: {
  home = {
    username = "avanderbergh";
    homeDirectory = "/home/avanderbergh";
    stateVersion = "23.11";

    packages = [
      pkgs.alejandra
      pkgs-stable.bitwig-studio
      pkgs.blender
      pkgs.brightnessctl
      pkgs-stable.calibre
      pkgs-stable.cava
      pkgs-stable.cura
      pkgs.davinci-resolve
      pkgs.discord-canary
      pkgs.esptool
      pkgs.expressvpn
      pkgs-stable.figma-agent
      pkgs.firefox
      pkgs.google-chrome
      pkgs.joshuto
      pkgs.ledger-live-desktop
      pkgs.libgen-cli
      pkgs.libresprite
      pkgs.logseq
      pkgs.ncdu
      pkgs.nsxiv
      pkgs.obsidian
      pkgs.openscad
      pkgs.orca-slicer
      pkgs.pcmanfm
      pkgs.pgcli
      pkgs.pinokio
      pkgs.signal-desktop
      pkgs.slack
      pkgs.telegram-desktop
      pkgs.unzip
      pkgs.wpsoffice
      pkgs.xarchiver
      pkgs.xclip
      pkgs.xdotool
      pkgs.xorg.xev
      pkgs.xsel
    ];
  };

  programs = {
    home-manager.enable = true;
    mpv.enable = true;
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
      allowCuda = true;
      allowUnfreePredicate = _: true;
    };
  };

  services.udiskie.enable = true;
}
