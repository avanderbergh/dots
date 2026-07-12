{
  flake.modules.homeManager."profile-desktop-swayidle" = _: {
    # Noctalia owns idle timeouts. Keep swayidle only as a logind event bridge
    # so external suspend paths (for example lid close) lock before sleeping.
    services.swayidle = {
      enable = true;
      events."before-sleep" = "noctalia msg session lock";
    };
  };
}
