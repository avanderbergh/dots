{pkgs, ...}: {
  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      input-fonts
      victor-mono
      roboto
      roboto-slab
      noto-fonts-emoji
      shantell-sans
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
