{config, ...}: let
  inherit (config.dots.packageSets) pkgs-master;
in {
  flake.modules.nixos.cloudflared = {config, ...}: let
    tunnelId = "e0b6e7f2-c209-4f32-b371-669a635695e1";
    tunnelUnit = "cloudflared-tunnel-${tunnelId}";
  in {
    services.cloudflared = {
      enable = true;
      # The eMudhra certificate fix requires cloudflared >= 2026.10.2 and Go >= 1.27.3.
      package = pkgs-master.cloudflared;
      tunnels = {
        "${tunnelId}" = {
          credentialsFile = config.sops.secrets.cloudflared-hermes-credentials.path;
          default = "http_status:404";
          ingress = {
            "ssh-hermes.adriaan.cc" = {
              service = "ssh://127.0.0.1:22";
            };
            "ha.adriaan.cc" = {
              service = "http://192.168.178.113:8123";
            };
            "chat.adriaan.cc" = {
              service = "http://127.0.0.1:8080";
            };
          };
        };
      };
    };

    # NixOS's cloudflared module passes credentialsFile via systemd LoadCredential,
    # so the service can stay unprivileged with DynamicUser=true while reading a 0400 root secret.
    sops.secrets.cloudflared-hermes-credentials = {
      key = "cloudflared/hermes/credentials";
      owner = "root";
      group = "root";
      mode = "0400";
      restartUnits = ["${tunnelUnit}.service"];
    };
  };
}
