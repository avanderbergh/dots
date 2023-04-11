{ pkgs, ... }: {
  services.xserver = {
    enable = true;
    displayManager = {
      gdm.enable = true;
      session = [{
        name = "bspwm";
        command = "${pkgs.bspwm}/bin/bspwm";
      }];
    };
  };
}
