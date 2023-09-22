{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      input-fonts
      noto-fonts
      noto-fonts-emoji
      roboto
      roboto-slab
      shantell-sans
      victor-mono
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
