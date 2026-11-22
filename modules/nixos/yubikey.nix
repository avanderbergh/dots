{
  flake.modules.nixos.yubikey = {pkgs, ...}: {
    # Enable smartcard daemon for YubiKey
    services.pcscd.enable = true;

    # Add udev rules for YubiKey and FIDO2 tokens
    services.udev.packages = with pkgs; [
      libfido2
      libu2f-host
      yubikey-personalization
    ];

    # Add YubiKey related packages
    environment.systemPackages = with pkgs; [
      libfido2
      yubikey-manager
      yubikey-personalization
    ];

    # We use a socket directory that persists across reboots
    programs.gnupg.agent.settings = {
      default-cache-ttl = 3600;
      max-cache-ttl = 7200;
    };
  };
}
