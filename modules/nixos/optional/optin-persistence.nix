{inputs, ...}: {
  imports = [inputs.impermanence.nixosModules.impermanence];

  environment.persistence."/persist" = {
    directories = [
      "/etc/NetworkManager/system-connections"
      "/etc/ssh"
      "/usr/share"
      "/var/lib/bluetooth"
      "/var/lib/boltd/"
      "/var/lib/colord"
      "/var/lib/nixos"
      "/var/lib/tailscale"
      "/var/lib/systemd/coredump"
      "/var/lib/upower"
      "/var/lib/sops"
      "/root/.gnupg"
    ];
    files = [
      "/var/lib/NetworkManager/secret_key"
      "/var/lib/NetworkManager/seen-bssids"
      "/var/lib/NetworkManager/timestamps"
    ];
  };
}
