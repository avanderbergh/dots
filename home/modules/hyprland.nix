{ ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    nvidiaPatches = true;
    extraConfig = ''
      # Environment

      exec-once = dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=hyprland

      # Keybindings

      $mod = SUPER

      bind = $mod, W, killactive,
      bind = $mod SHIFT, Q, exit,

      bind = $mod, left, movefocus, l
      bind = $mod, right, movefocus, r
      bind = $mod, up, movefocus, u
      bind = $mod, down, movefocus, d

      bind = $mod, S, submap, resize

      submap = resize
      binde = , right, resizeactive, 10 0
      binde = , left, resizeactive, -10 0
      binde = , up, resizeactive, 0 -10
      binde = , down, resizeactive, 0 10
      bind = , escape, submap, reset
      submap = reset

      # Programs
      bind = $mod, Return, exec, alacritty
      bindr = $mod, SUPER_L, exec, pkill wofi || wofi --show=drun
    '';
  };
}
