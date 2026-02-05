{
  pkgs,
  pkgs-stable,
  pkgs-master,
  ...
}: {
  home = {
    username = "avanderbergh";
    homeDirectory = "/home/avanderbergh";
    stateVersion = "23.11";

    packages = [
      pkgs-stable.bitwig-studio
      pkgs-stable.calibre
      pkgs-stable.cava
      # pkgs-stable.cura
      # pkgs-stable.figma-agent
      pkgs-stable.openscad
      pkgs-stable.orca-slicer
      pkgs-stable.pcmanfm
      pkgs.alejandra
      pkgs.nixd
      pkgs.blender
      pkgs.brightnessctl
      pkgs.code-cursor
      pkgs.davinci-resolve
      pkgs.discord-canary
      pkgs.esptool
      pkgs.firefox
      pkgs.font-manager
      pkgs.google-chrome
      pkgs.joshuto
      pkgs.ledger-live-desktop
      pkgs.libgen-cli
      pkgs.libresprite
      pkgs.ncdu
      pkgs.nsxiv
      pkgs.nvtopPackages.full
      pkgs.obsidian
      pkgs.pgcli
      pkgs.pinokio
      pkgs.signal-desktop-bin
      pkgs.slack
      pkgs.steam-run
      pkgs.telegram-desktop
      pkgs.unzip
      pkgs.wpsoffice
      pkgs.xarchiver
      pkgs.xclip
      pkgs.xdotool
      pkgs.xorg.xev
      pkgs.xsel
      pkgs.zoom-us
    ];
  };

  programs = {
    home-manager.enable = true;
    mpv.enable = true;
    pandoc.enable = true;
    vscode = {
      enable = true;
      package = pkgs-master.vscode.fhs;
    };
    zathura.enable = true;
  };

  services.udiskie.enable = true;
}
