_: {
  services.wpaperd = {
    enable = true;
    settings = {
      default = {
        duration = "30m";
        mode = "center";
        sorting = "ascending";
      };

      any = {
        path = "${../images/wallpaper.jpg}";
      };
    };
  };
}
