{
  pkgs,
  lib,
  ...
}: {
  security.rtkit.enable = true;

  services = {
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    alsa-topology-conf
    alsa-ucm-conf
    alsa-utils
    easyeffects
    helvum
    pavucontrol
  ];
}
