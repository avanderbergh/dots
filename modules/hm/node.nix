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
      # TODO: This find a way to update the path to the latest version
      PUPPETEER_EXECUTABLE_PATH = "${pkgs.playwright-driver.browsers}/chromium-1080/chrome-linux/chrome";
    };
  };
}
