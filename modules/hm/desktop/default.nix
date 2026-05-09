{
  config,
  inputs,
  ...
}: let
  hm = config.flake.modules.homeManager;
in {
  flake.modules.homeManager."integration-zoidberg-desktop" = {
    imports = [
      inputs.stylix.homeModules.stylix
      inputs.niri.homeModules.config
    ];
  };

  flake.modules.homeManager."profile-desktop" = _: let
    browser = ["google-chrome.desktop"];
  in {
    imports = [
      hm."profile-desktop-fuzzel"
      hm."profile-desktop-niri"
      hm."profile-desktop-obs"
      hm."profile-desktop-screenshots"
      hm."profile-desktop-swayidle"
      hm."profile-desktop-swaylock"
      hm."profile-desktop-swaync"
      hm."profile-desktop-waybar"
      hm."profile-desktop-wpaperd"
      hm."profile-desktop-kanshi"
    ];

    gtk = {
      enable = true;
      gtk4.theme = null;
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
  };
}
