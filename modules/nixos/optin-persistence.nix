{inputs, ...}: {
  flake.modules.nixos."optin-persistence" = {
    imports = [inputs.impermanence.nixosModules.impermanence];

    environment.persistence."/persist" = {
      directories = [
        "/etc/NetworkManager/system-connections"
        "/etc/ssh"
        "/var/lib/bluetooth"
        "/var/lib/boltd"
        "/var/lib/colord"
        "/var/lib/nixos"
        "/var/lib/tailscale"
        "/var/lib/systemd"
        "/var/lib/upower"
      ];
      files = [
        "/var/lib/NetworkManager/secret_key"
      ];
    };
  };
}
