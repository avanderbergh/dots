{
  pkgs,
  pkgs-stable,
  pkgs-master,
  ...
}: {
  home.packages = [
    pkgs-stable.bitwig-studio
    pkgs-stable.calibre
    pkgs-stable.openscad
    pkgs-stable.orca-slicer
    pkgs-stable.pcmanfm
    pkgs.blender
    pkgs.brightnessctl
    pkgs.code-cursor
    pkgs.davinci-resolve
    pkgs.discord-canary
    pkgs.firefox
    pkgs.font-manager
    pkgs.google-chrome
    pkgs.ledger-live-desktop
    pkgs.libresprite
    pkgs.nsxiv
    pkgs.obsidian
    pkgs.pinokio
    pkgs.signal-desktop-bin
    pkgs.slack
    pkgs.steam-run
    pkgs.telegram-desktop
    pkgs.wl-clipboard
    pkgs.wpsoffice
    pkgs.xarchiver
    pkgs.xclip
    pkgs.xdotool
    pkgs.xev
    pkgs.xsel
    pkgs.zoom-us
  ];

  programs = {
    alacritty = {
      enable = true;
      settings = {
        env.TERM = "xterm-256color";
        window = {
          padding = {
            x = 10;
            y = 10;
          };
        };
      };
    };

    mpv.enable = true;
    vscode = {
      enable = true;
      package = pkgs-master.vscode.fhs;
    };
    zathura.enable = true;
  };

  services.udiskie.enable = true;
}
