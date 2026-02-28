{pkgs, ...}: let
  browser = ["google-chrome.desktop"];
in {
  imports = [
    ./common/fuzzel.nix
    ./common/niri.nix
    ./common/obs.nix
    ./common/screenshots.nix
    ./common/swayidle.nix
    ./common/swaylock.nix
    ./common/swaync.nix
    ./common/waybar.nix
    ./common/wpaperd.nix
    ./kanshi.nix
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
      "x-scheme-handler/about" = browser;
      "x-scheme-handler/unknown" = browser;
      "x-scheme-handler/webcal" = browser;
      "x-scheme-handler/mailto" = browser;
      "x-scheme-handler/chrome" = ["google-chrome.desktop"];
      "application/x-extension-htm" = browser;
      "application/x-extension-html" = browser;
      "application/x-extension-shtml" = browser;
      "application/xhtml+xml" = browser;
      "application/x-extension-xhtml" = browser;
      "application/x-extension-xht" = browser;
      "inode/directory" = ["pcmanfm.desktop"];
      "application/pdf" = ["zathura.desktop"];
      "video/*" = ["mpv.desktop"];
      "audio/*" = ["mpv.desktop"];
      "image/*" = ["nsxiv.desktop"];
    };
  };

  home.sessionVariables = {
    BROWSER = "google-chrome-stable";
    DEFAULT_BROWSER = "google-chrome-stable";
  };
}
