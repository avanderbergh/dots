{
  flake.modules.nixos."cloudflare-ssh-ca" = {
    config,
    pkgs,
    ...
  }: let
    owner = config.local.users.ownerName;
    cloudflareCaKey = pkgs.writeText "cloudflare-ca.pub" ''
      ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBOzn7HAZE/Kq/O3pTUlvIZHUI4NV47iKW+rlbfZfCzxY24cN4AAEFFBdV1RuG/Zi/6SKoVnvtBjElI1hT5buHFY= open-ssh-ca@cloudflareaccess.org
    '';
  in {
    services.openssh.settings = {
      PubkeyAuthentication = true;
      TrustedUserCAKeys = "${cloudflareCaKey}";
      # Prefer modern ETM MACs while keeping hmac-sha2-256 for Cloudflare
      # browser-rendered SSH compatibility.
      Macs = [
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-256-etm@openssh.com"
        "umac-128-etm@openssh.com"
        "hmac-sha2-256"
      ];
    };

    users.users.${owner}.openssh.authorizedPrincipals = [owner];
  };
}
