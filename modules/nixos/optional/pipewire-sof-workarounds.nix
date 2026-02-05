# This module contains workarounds for PipeWire/WirePlumber issues specifically
# related to Intel Sound Open Firmware (SOF) devices, often found on newer Dell XPS
# and other laptops (e.g., sof-soundwire).
# These issues typically manifest as "Broken pipe" errors, "resync" messages in logs,
# audio stuttering, choppiness, or complete audio failure, especially under load
# (e.g., video calls).
# Troubleshooting:
# If audio problems persist with this configuration:
# 1. Monitor user journal logs: journalctl --user -f | grep 'pipewire\|wireplumber\|alsa'
# 2. Look for "Broken pipe" or "resync" errors related to "hw:sofsoundwire".
# 3. Try adjusting the 'api.alsa.headroom' value below. Increase it further (e.g., 32768)
#    if errors persist, or decrease it (e.g., 8192, 4096) if latency becomes noticeable.
# 4. Less likely, but 'api.alsa.period-size' could also be adjusted (powers of 2).
# 5. Check PipeWire/WirePlumber/SOF bug trackers for hardware-specific issues.
{
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
}
