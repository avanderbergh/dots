{pkgs, ...}: {
  home = {
    packages = [
      pkgs.nodePackages_latest.nodejs
      pkgs.nodePackages_latest.node-gyp-build
      pkgs.pnpm
      pkgs.zx
      pkgs.playwright
      pkgs.playwright-test
    ];

    sessionVariables = {
      SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
    };
  };
}
