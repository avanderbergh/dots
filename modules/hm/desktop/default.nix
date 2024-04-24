{pkgs, ...}: let
  browser = ["google-chrome.desktop"];
in {
  imports = [
    ./common/bspwm.nix
    ./common/dunst.nix
    ./common/flameshot.nix
    ./common/pavucontrol.nix
    ./common/picom.nix
    ./common/rofi.nix
    ./common/spotify.nix
    ./common/sxhkd.nix
    ./common/wallpapers.nix
    ./common/eww
    ./common/syncthing.nix
  ];

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Pink-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = ["pink"];
        variant = "mocha";
      };
    };
    cursorTheme = {
      name = "Catppuccin-Mocha-Dark-Cursors";
      package = pkgs.catppuccin-cursors.mochaDark;
      size = 48;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = browser;
      "text/plain" = ["code.desktop"];
      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
      "inode/directory" = ["pcmanfm.desktop"];
      "application/pdf" = ["zathura.desktop"];
      "video/*" = ["mpv.desktop"];
      "audio/*" = ["mpv.desktop"];
      "image/*" = ["nsxiv.desktop"];
    };
  };
}
