{pkgs, ...}: {
  services = {
    libinput.touchpad.clickMethod = "clickfinger";
    logind.lidSwitch = "lock";
  };
}
