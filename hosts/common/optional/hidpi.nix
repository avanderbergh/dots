{pkgs, ...}: {
  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
  services.xserver.dpi = 192;
  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
  };
  fonts.fontconfig = {
    antialias = false;
    subpixel = {
      rgba = "none";
      lcdfilter = "none";
    };
  };
}
