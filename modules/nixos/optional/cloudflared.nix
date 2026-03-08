{lib, ...}: let
  tunnelId = "e0b6e7f2-c209-4f32-b371-669a635695e1";
  tunnelUnit = "cloudflared-tunnel-${tunnelId}";
in {
  services.cloudflared = {
    enable = true;
    tunnels = {
      "${tunnelId}" = {
        credentialsFile = "/run/secrets/cloudflared-hermes-credentials";
        default = "http_status:404";
        ingress = {
          "ssh-hermes.adriaan.cc" = {
            service = "ssh://127.0.0.1:22";
          };
        };
      };
    };
  };

  # cloudflared tunnel units use DynamicUser by default; make this tunnel run as
  # root so it can read a root-owned 0400 credentials file from /run/secrets.
  systemd.services."${tunnelUnit}".serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = lib.mkForce "root";
  };

  sops.secrets.cloudflared-hermes-credentials = {
    key = "cloudflared/hermes/credentials";
    owner = "root";
    group = "root";
    mode = "0400";
  };
}
