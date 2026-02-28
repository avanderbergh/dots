_: {
  programs.niri.settings = {
    # Stylix integration from niri-flake owns cursor and border visuals.
    # Keep this module on programs.niri.settings and avoid programs.niri.config.
    input.keyboard.xkb.options = "compose:ralt,ctrl:nocaps";

    environment = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
      SDL_VIDEODRIVER = "wayland";
    };

    "screenshot-path" = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

    binds = {
      "Super+Space".action.spawn = "fuzzel";
      "Super+Return".action.spawn = "alacritty";
      "Print".action.spawn = "screenshot-region";
      "Ctrl+Print".action.spawn = "screenshot-screen";
    };
  };
}
