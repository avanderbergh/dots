{pkgs, ...}: let
  browser = ["google-chrome.desktop"];
in {
  imports = [
    ./common/bspwm.nix
    ./common/dunst.nix
    ./common/eww
    ./common/flameshot.nix
    ./common/obs.nix
    ./common/picom.nix
    ./common/rofi.nix
    ./common/sxhkd.nix
    ./common/syncthing.nix
  ];

  gtk = {
    enable = true;
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
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
