{
  flake.modules.nixos.openthread = {
    services.openthread-border-router = {
      enable = true;
      openFirewall = true;

      # TODO: Replace with Farnsworth's actual network interface.
      # Run `ip link` on the host to find it (e.g. "eno1", "enp4s0").
      backboneInterfaces = ["CHANGE_ME"];

      radio = {
        # TODO: Replace with the actual device path after plugging in the dongle.
        # Run `ls /dev/serial/by-id/` on the host to find it. The SONOFF MG24
        # should appear as something like:
        #   /dev/serial/by-id/usb-Itead_Sonoff_Zigbee_3.0_USB_Dongle_Plus_<serial>-if00-port0
        #
        # Note: The dongle ships with Zigbee (EZSP) firmware. To use it as a
        # Thread radio, flash it with Thread RCP firmware first using the
        # SONOFF Dongle Flasher web tool or add-on. The dongle can only run
        # one radio protocol at a time (Zigbee OR Thread, not both).
        device = "/dev/serial/by-id/usb-Itead_Sonoff_Zigbee_3.0_USB_Dongle_Plus_CHANGE_ME-if00-port0";
        baudRate = 460800; # Common for EFR32MG24 Thread RCP firmware
        flowControl = false; # Adjust if the firmware requires hardware flow control
      };

      web.enable = true; # Web UI for Thread network management (port 8082)
    };
  };
}