{
  hostConfig,
  pkgs,
  ...
}: let
  script = pkgs.writeShellScript "bspwm_workspaces" ''
    #!/bin/sh

    total=`xdotool get_num_desktops`

    bspc subscribe desktop_focus node_add node_remove 2> /dev/null | while read line; do
      currwp=`xdotool get_desktop`
      i=0
      while [ $i -lt $total ]
      do
          if [ $i -eq $currwp ]
          then
              eww update desktop_`expr $i + 1`="desktop_active"
          else
              if [ `bspc query -N -d ^$(expr $i + 1) | wc -l` -gt 0 ]
              then
                  eww update desktop_`expr $i + 1`="desktop_inactive"
              else
                  eww update desktop_`expr $i + 1`="desktop_unused"
              fi
          fi
          i=`expr $i + 1`
      done
      echo cycle
    done
  '';
in {
  xsession = {
    enable = true;
    windowManager.bspwm = {
      enable = true;
      monitors = hostConfig.monitors;
      settings = {
        gapless_monocle = true;
        border_width = 3;
      };
      extraConfig = ''
        bspc config pointer_modifier mod4
        bspc config pointer_action1 move
        bspc config pointer_action2 resize_corner
        bspc config pointer_action3 resize_side
      '';
      startupPrograms = [
        "eww daemon"
        "eww open top_left"
        "eww open top_center"
        "eww open top_right"
        "autorandr --change"
      ];
    };
  };
  systemd.user.services.bspwm_workspaces = {
    Unit.Description = "BSPWM Workspaces Service";
    Service = {
      ExecStart = "${script}";
      Restart = "always";
      Environment = [
        "PATH=/etc/profiles/per-user/avanderbergh/bin:/run/current-system/sw/bin"
      ];
    };
    Install.WantedBy = ["default.target"];
  };
}
