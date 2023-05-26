{pkgs, ...}: {
  services.picom = {
    enable = true;
    fade = true;
    backend = "glx";
    settings = {
      corner-radius = 10;
      use-damage = false;
      vsync = true;
    };
    package = pkgs.picom-next;
  };
}
