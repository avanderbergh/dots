{...}: {
  services.cloudflared = {
    enable = true;
    tunnels = {
      "e0b6e7f2-c209-4f32-b371-669a635695e1" = {
        credentialsFile = "/run/secrets/cloudflared-hermes-credentials";
        default = "http_status:404";
        ingress = {
          "ssh.hermes.adriaan.cc" = {
            service = "ssh://127.0.0.1:22";
          };
        };
      };
    };
  };

  sops.secrets.cloudflared-hermes-credentials = {
    key = "cloudflared/hermes/credentials";
    owner = "cloudflared";
    group = "cloudflared";
    mode = "0400";
  };
}
