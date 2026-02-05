{pkgs, ...}: {
  programs.mise = {
    enable = true;
    enableBashIntegration = true;
    package = pkgs.mise;
  };
}
