{pkgs, ...}: let
  browser = ["google-chrome.desktop"];
in {
  imports = [
    ./common/bspwm.nix
    ./common/dunst.nix
    ./common/eww
    ./common/flameshot.nix
    ./common/obs.nix
    ./common/pavucontrol.nix
    ./common/picom.nix
    ./common/rofi.nix
    ./common/sxhkd.nix
    ./common/syncthing.nix
    ./common/wallpapers.nix
  ];

  gtk = {
    enable = true;
    catppuccin.enable = true;
  };

  catppuccin.enable = true;

  qt = {
    enable = true;
    style.name = "kvantum";
    platformTheme.name = "kvantum";
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
