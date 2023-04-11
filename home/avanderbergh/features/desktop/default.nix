{
  services.polybar.enable = true;
  xsession.windowManager.bspwm.enable = true;
  programs.rofi.enable = true;

  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Standard-Pink-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "pink" ];
        variant = "mocha";
      };
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
  };

}
