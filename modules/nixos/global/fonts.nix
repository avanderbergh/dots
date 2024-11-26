{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      input-fonts
      noto-fonts
      noto-fonts-emoji
      recursive
      roboto
      roboto-slab
      shantell-sans
      victor-mono
      (nerdfonts.override {fonts = ["VictorMono" "Noto" "Recursive"];})
    ];

    fontconfig = {
      defaultFonts = {
        serif = ["RecMonoCasual Nerd Font Propo"];
        sansSerif = ["RecMonoLinear Nerd Font Propo"];
        monospace = ["RecMonoLinear Nerd Font Mono"];
      };
    };
  };
}
