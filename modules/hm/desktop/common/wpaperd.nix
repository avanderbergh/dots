{lib, ...}: {
  services.wpaperd = {
    enable = true;

    # Stylix provides services.wpaperd.settings.any.{path,mode}.
    # Keep this module to behavioral defaults only so wallpaper follows Stylix.
    settings = {
      default = {
        duration = lib.mkDefault "30m";
        sorting = lib.mkDefault "ascending";
      };
    };
  };
}
