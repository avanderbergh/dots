{pkgs, ...}: {
  home = {
    packages = [
      pkgs.nodejs_latest
      pkgs.node-gyp-build
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
