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
      pkgs-stable.figma-agent
      pkgs.firefox
      pkgs.font-manager
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
      userSettings = {
        "window.menuBarVisibility" = "toggle";
      };
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
