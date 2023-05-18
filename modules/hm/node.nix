{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      nodejs_20
      nodePackages.degit
      nodePackages.node-gyp-build
      nodePackages.pnpm
      nodePackages.zx
      playwright-driver

      # For node-gyp-build
      gnat
      gnumake
    ];

    sessionVariables = {
      PLAYWRIGHT_BROWSERS_PATH = "${pkgs.playwright-driver.browsers}";
    };
  };
}
