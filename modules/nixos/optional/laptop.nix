{
  services = {
    libinput.touchpad.clickMethod = "clickfinger";
    logind = {
      enable = true;
      lidSwitch = "ignore";
    };
    acpid = {
      enable = true;
      extraRules = ''
        event=button/lid.*
        action=/etc/acpi/handle-lid.sh %e
      '';
    };

    # To switch off the display when the lid is closed.
    environment.etc."acpi/handle-lid.sh".text = ''
      #!/usr/bin/env bash

      export DISPLAY=:0
      export XAUTHORITY=/home/avanderbergh/.Xauthority

      # Get the lid state from the event parameter
      lid_state=$(echo $@ | awk '{print $3}')

      if [ "$lid_state" = "close" ]; then
        logger "Lid closed: turning off display"
        su avanderbergh -c "xset dpms force off"
      elif [ "$lid_state" = "open" ]; then
        logger "Lid opened: turning on display"
        su avanderbergh -c "xset dpms force on"
      fi
    '';

    environment.etc."acpi/handle-lid.sh".mode = "0755";
  };
}
