{pkgs, ...}: {
  console.font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";

  fonts.fontconfig = {
    antialias = false;
    subpixel = {
      rgba = "none";
      lcdfilter = "none";
    };
  };
}
