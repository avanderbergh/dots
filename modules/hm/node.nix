{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      nodePackages_latest.nodejs
      nodePackages_latest.node-gyp-build
      pnpm
      zx
      playwright
      playwright-test
    ];
  };
}
