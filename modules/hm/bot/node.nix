{
  pkgs,
  pkgs-master,
  ...
}: {
  home = {
    packages =
      (with pkgs; [
        nodePackages_latest.nodejs
        pnpm
        zx
      ])
      ++ [ pkgs-master.codex ];

    sessionVariables = {
      SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
    };
  };
}
