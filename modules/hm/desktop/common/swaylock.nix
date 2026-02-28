{pkgs, ...}: {
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      clock = true;
      screenshots = true;
      indicator = true;
      daemonize = true;
      grace = 2;
      "fade-in" = "0.2";
      "ignore-empty-password" = true;
      "show-failed-attempts" = true;
      "indicator-radius" = 120;
      "indicator-thickness" = 10;
      "effect-blur" = "7x4";
    };
  };
}
