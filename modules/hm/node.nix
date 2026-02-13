{pkgs, ...}: let
  goTools = import ./go.nix {inherit pkgs;};
in {
  home = {
    packages = [
      pkgs.nodePackages_latest.nodejs
      pkgs.nodePackages_latest.node-gyp-build
      pkgs.pnpm
      pkgs.zx
      pkgs.playwright
      pkgs.playwright-test
    ] ++ goTools;

    sessionVariables = {
      SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
    };
  };
}
