{pkgs, ...}: {
  imports = [
    ./common/bspwm.nix
    ./common/dunst.nix
    ./common/pavucontrol.nix
    ./common/picom.nix
    ./common/polybar.nix
    ./common/rofi.nix
    ./common/sxhkd.nix
    ./common/wallpapers.nix
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
    platformTheme = "gtk";
  };
}
