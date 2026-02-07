{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.openclaw = {
    enable = true;
    package = pkgs.openclaw-gateway;
    installApp = false;

    # Disable the only bundled plugin that is enabled by default.
    bundledPlugins.goplaces.enable = false;
  };

  systemd.user.services.openclaw-gateway.Service.Environment = lib.mkAfter [
    "PATH=/etc/profiles/per-user/${config.home.username}/bin:/run/current-system/sw/bin:/bin"
  ];
}
