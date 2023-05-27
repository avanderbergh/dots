{pkgs, ...}: {
  services.picom = {
    enable = true;
    fade = true;
    backend = "glx";
    settings = {
      corner-radius = 10;
      use-damage = false;
      vsync = true;
      blur-method = "dual_kawase";
      blur-strength = 5;
      blur-background-frame = true;
      blur-background-fixed = true;
      blur-background = true;
    };
    package = pkgs.picom-next;
  };
}
