{pkgs, ...}: {
  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      victor-mono
      roboto
      roboto-slab
      noto-fonts-emoji
      (nerdfonts.override {fonts = ["VictorMono" "Noto"];})
    ];

    fontconfig = {
      defaultFonts = {
        serif = ["Roboto Slab"];
        sansSerif = ["Roboto"];
        monospace = ["Victor Mono"];
      };
    };
  };
}
