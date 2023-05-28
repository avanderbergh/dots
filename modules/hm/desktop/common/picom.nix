{pkgs, ...}: {
  services.picom = {
    enable = true;
    fade = true;
    backend = "glx";
    settings = {
      blur-background = true;
      blur-background-fixed = true;
      blur-background-frame = true;
      blur-method = "dual_kawase";
      blur-strength = 5;
      corner-radius = 5;
      detect-rounded-corners = true;
      experimental-backends = true;
      round-borders = true;
      use-damage = false;
      vsync = true;
      xrender-sync-fence = false;
    };
    package = pkgs.picom-jonaburg;
  };
}
