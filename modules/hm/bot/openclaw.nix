{...}: {
  programs.openclaw = {
    enable = true;
    installApp = false;

    # Disable the only bundled plugin that is enabled by default.
    bundledPlugins.goplaces.enable = false;

    config.gateway.mode = "local";
  };
}
