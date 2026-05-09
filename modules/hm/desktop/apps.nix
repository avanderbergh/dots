{config, ...}: let
  inherit (config.dots.packageSets) pkgs-master pkgs-stable;
in {
  flake.modules.homeManager."profile-desktop-apps" = {pkgs, ...}: {
    home.packages = [
      pkgs-stable.bitwig-studio
      pkgs-stable.calibre
      pkgs-stable.openscad
      pkgs-stable.orca-slicer
      pkgs-stable.pcmanfm
      pkgs.blender
      pkgs.brightnessctl
      pkgs.code-cursor
      pkgs-stable.discord-canary
      pkgs.firefox
      pkgs.font-manager
      pkgs.google-chrome
      pkgs.ledger-live-desktop
      pkgs.libresprite
      pkgs.nsxiv
      pkgs.obsidian
      pkgs.pinokio
      pkgs.signal-desktop
      pkgs.slack
      pkgs.steam-run
      pkgs.telegram-desktop
      pkgs.wl-clipboard
      pkgs.wpsoffice
      pkgs.wev
      pkgs.xarchiver
      pkgs.grim
      pkgs.slurp
      pkgs.satty
      pkgs.zoom-us
      pkgs.opencode-desktop
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
  };
}
