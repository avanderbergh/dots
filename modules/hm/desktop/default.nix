{pkgs, ...}: {
  imports = [
    ./common/bspwm.nix
    ./common/dunst.nix
    ./common/pavucontrol.nix
    ./common/picom.nix
    ./common/rofi.nix
    ./common/spotify.nix
    ./common/sxhkd.nix
    ./common/wallpapers.nix
    ./common/eww
  ];

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Pink-dark";
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
    platformTheme = "gtk";
  };
}
