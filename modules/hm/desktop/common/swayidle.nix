{
  flake.modules.homeManager."profile-desktop-swayidle" = {
    config,
    lib,
    ...
  }: {
    # Noctalia owns idle timeouts. Keep swayidle only as a logind event bridge
    # so external suspend paths (for example lid close) lock before sleeping.
    services.swayidle = {
      enable = true;
      events."before-sleep" = "${lib.getExe' config.programs.noctalia.package "noctalia"} msg session lock";
    };
  };
}
