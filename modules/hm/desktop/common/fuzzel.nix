{lib, ...}: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = lib.mkDefault "alacritty";
        layer = lib.mkDefault "overlay";
        width = lib.mkDefault 64;
        horizontal-pad = lib.mkDefault 24;
        vertical-pad = lib.mkDefault 16;
        "inner-pad" = lib.mkDefault 10;
        lines = lib.mkDefault 12;
      };

      border = {
        width = lib.mkDefault 2;
        radius = lib.mkDefault 14;
      };

      dmenu = {
        exit-immediately-if-empty = lib.mkDefault "yes";
      };
    };
  };
}
