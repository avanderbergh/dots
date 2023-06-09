{inputs, ...}: {
  imports = [inputs.impermanence.nixosModules.impermanence];

  environment.persistence."/persist" = {
    directories = [
      "/etc/NetworkManager/system-connections"
      "/usr/share"
      "/var/lib/bluetooth"
      "/var/lib/boltd/"
      "/var/lib/colord"
      "/var/lib/systemd/coredump"
      "/var/lib/upower"
      "/var/lib/expressvpn"
    ];
    files = [
      "/var/lib/NetworkManager/secret_key"
      "/var/lib/NetworkManager/seen-bssids"
      "/var/lib/NetworkManager/timestamps"
    ];
  };
}
