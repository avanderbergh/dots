{pkgs, ...}: {
  services.swayidle = {
    enable = true;
    events = {
      "before-sleep" = "swaylock -f";
      lock = "swaylock -f";
    };
    timeouts = [
      {
        timeout = 300;
        command = "swaylock -f";
      }
      {
        timeout = 600;
        command = "niri msg action power-off-monitors";
      }
      {
        timeout = 1200;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
  };
}
