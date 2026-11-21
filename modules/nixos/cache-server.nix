{
  flake.modules.nixos."cache-server" = {pkgs, ...}: {
    services.nix-serve = {
      enable = true;
      package = pkgs.nix-serve-ng;
      openFirewall = true;
      secretKeyFile = "/var/cache-priv-key.pem";
    };

    environment.persistence."/persist".files = ["/var/cache-priv-key.pem"];
  };
}
