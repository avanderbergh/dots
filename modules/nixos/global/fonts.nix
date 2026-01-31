{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      input-fonts
      noto-fonts
      noto-fonts-color-emoji
      recursive
      roboto
      roboto-slab
      shantell-sans
      victor-mono
      nerd-fonts.departure-mono
      nerd-fonts.proggy-clean-tt
      nerd-fonts.noto
      nerd-fonts.recursive-mono
      nerd-fonts.victor-mono
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
