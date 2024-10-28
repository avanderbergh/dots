{pkgs, ...}: {
  services.nix-serve = {
    enable = true;
    openFirewall = true;
    secretKeyFile = "/var/cache-priv-key.pem";
  };

  environment.persistence."/persist".files = ["/var/cache-priv-key.pem"];

  environment.systemPackages = with pkgs; [
    gh
  ];
}
