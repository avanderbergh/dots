{pkgs, ...}: {
  services.picom = {
    enable = true;
    fade = true;
    backend = "glx";
    settings = {
      blur = {
        method = "dual_kawase";
        radius = 10;
        strength = 5;
      };
    };
  };
}
