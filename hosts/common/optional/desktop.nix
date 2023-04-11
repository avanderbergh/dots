{ pkgs, ... }: {
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    windowManager.bspwm.enable = true;
  };
}
