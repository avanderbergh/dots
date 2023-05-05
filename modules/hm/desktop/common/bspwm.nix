{monitor, ...}: {
  xsession = {
    enable = true;
    windowManager.bspwm = {
      enable = true;
      monitors = {"${monitor}" = ["code" "term" "web" "chat" "music" "prod"];};
      extraConfig = ''
        bspc config pointer_modifier mod4
        bspc config pointer_action1 move
        bspc config pointer_action2 resize_corner
        bspc config pointer_action3 resize_side
      '';
    };
  };
}
