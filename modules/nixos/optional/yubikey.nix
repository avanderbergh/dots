{pkgs, ...}: {
  # Enable smartcard daemon for YubiKey
  services.pcscd.enable = true;

  # Add udev rules for YubiKey
  services.udev.packages = with pkgs; [
    yubikey-personalization
    libu2f-host
  ];

  # Add YubiKey related packages
  environment.systemPackages = with pkgs; [
    yubikey-personalization
    yubikey-manager
  ];

  # We use a socket directory that persists across reboots
  programs.gnupg.agent.settings = {
    default-cache-ttl = 3600;
    max-cache-ttl = 7200;
  };
}
