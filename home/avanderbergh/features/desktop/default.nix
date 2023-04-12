{pkgs, ...}: {
  imports = [
    ./common/bspwm.nix
    ./common/pavucontrol.nix
    ./common/polybar.nix
    ./common/sxhkd.nix
  ];

  programs.rofi.enable = true;

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
