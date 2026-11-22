{
  flake.modules.nixos.yubikey = {pkgs, ...}: {
    # Enable smartcard daemon for YubiKey PIV (age-plugin-yubikey) and ykman.
    services.pcscd.enable = true;

    # Add udev rules for YubiKey and FIDO2 tokens.
    services.udev.packages = with pkgs; [
      libfido2
      libu2f-host
      yubikey-personalization
    ];

    # Add YubiKey and FIDO2 management packages.
    environment.systemPackages = with pkgs; [
      libfido2
      yubikey-manager
    ];
  };
}
