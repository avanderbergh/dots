{pkgs, ...}: {
  services = {
    libinput.touchpad = {
      clickMethod = "clickfinger";
      disableWhileTyping = true;
      sendEventsMode = "disabled-on-external-mouse";
    };
    logind.lidSwitch = "lock";
  };
}
