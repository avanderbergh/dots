{
  flake.modules.nixos."pipewire-sof-workarounds" = {
    services.pipewire = {
      # Increase global quantum and rate to help with buffer underruns
      extraConfig.pipewire = {
        "99-sof-higher-latency" = {
          "context.properties" = {
            # Increase default quantum (buffer size) for more stability
            "default.clock.quantum" = 1024;
            # Higher rate for more precise timing
            "default.clock.rate" = 48000;
            # Minimum quantum size - prevent going too small
            "default.clock.min-quantum" = 1024;
          };
        };
      };

      wireplumber.extraConfig = {
        # Tweak ALSA buffer properties for sof-soundwire devices
        "51-alsa-sof-tweaks" = {
          "monitor.alsa.rules" = [
            {
              matches = [
                {"node.name" = "~alsa_output.*sof-soundwire.*";}
                {"node.name" = "~alsa_input.*sof-soundwire.*";}
              ];
              actions = {
                "update-props" = {
                  # api.alsa.period-size: Controls ALSA interrupt frequency. Default 1024.
                  "api.alsa.period-size" = 2048; # Increased from 1024
                  # api.alsa.headroom: Adds extra safety buffer (samples) to prevent underruns.
                  # Increased from default 0 due to instability.
                  "api.alsa.headroom" = 32768; # Increased from 16384
                  # Increase periods in hardware buffer
                  "api.alsa.period-num" = 4; # Default is usually 2
                  # Disable batch mode which can cause issues with pointer updates
                  "api.alsa.disable-batch" = true;
                  # Disable mmap access which can be unstable on some hardware
                  "api.alsa.disable-mmap" = true;
                  # Use standard IO read/write operations instead of mmap
                  "api.alsa.use-io-wait" = false;
                };
              };
            }
          ];
        };

        # Disable node suspension to prevent glitches/crashes on wake-up
        # See: https://wiki.archlinux.org/title/PipeWire#Noticeable_audio_delay_or_audible_pop/crack_when_starting_playback
        "51-disable-suspension.conf" = {
          "monitor.alsa.rules" = [
            {
              matches = [
                {"node.name" = "~alsa_input.*";} # All inputs
                {"node.name" = "~alsa_output.*";} # All outputs
              ];
              actions = {
                "update-props" = {
                  # session.suspend-timeout-seconds: Timeout before suspending idle nodes.
                  # 0 disables suspension completely. Default is usually 5.
                  "session.suspend-timeout-seconds" = 0;
                };
              };
            }
          ];
        };
      };
    };
  };
}
