{pkgs, ...}: {
  services = {
    libinput.touchpad.clickMethod = "clickfinger";
    logind = {
      enable = true;
      lidSwitch = "ignore";
    };
    acpid = {
      enable = true;

      lidEventCommands = {
        opened = ''
          export DISPLAY=:0
          export XAUTHORITY=/home/avanderbergh/.Xauthority
          su avanderbergh -c "xset dpms force on"
        '';
        closed = ''
          export DISPLAY=:0
          export XAUTHORITY=/home/avanderbergh/.Xauthority
          su avanderbergh -c "xset dpms force off"
        '';
      };
    };
  };
  environment.systemPackages = with pkgs; [
    xorg.xset
  ];
}
