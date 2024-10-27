{pkgs, ...}: {
  services = {
    libinput.touchpad.clickMethod = "clickfinger";
    services.logind.lidSwitch = "lock";
  };
}
