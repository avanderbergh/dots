{
  pkgs,
  colors,
  ...
}: {
  services.xserver = {
    enable = true;
    displayManager = {
      lightdm = {
        enable = true;
        background = "/usr/share/background.jpg";
        greeters = {
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
            extraConfig = ''
              [greeter]
              xft-dpi = 261
            '';
          };
        };
      };
    };
    windowManager.bspwm.enable = true;
  };
}
