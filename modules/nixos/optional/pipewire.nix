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
      # Add custom config files
      extraConfig = {
        pipewire = {
          "99-chrome-fix" = {
            context.properties = {
              default.clock.min-quantum = 128; # Try lower values like 64 if still choppy
              default.clock.quantum = 1024; # Default is 1024, try 2048 if still choppy
              default.clock.rate = 48000; # Common sample rate
              core.daemon = true;
              core.clock.power-of-two-quantum = true;
            };
          };
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    pavucontrol
    alsa-utils
    helvum
    easyeffects
  ];
}
