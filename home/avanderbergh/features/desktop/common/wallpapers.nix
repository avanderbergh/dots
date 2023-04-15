{
  home.file.wallpapers = {
    enable = true;
    source = ../images;
    target = "wallpapers/";
  };

  services.random-background = {
    enable = true;
    imageDirectory = "%h/wallpapers";
  };
}
