{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.quickemu
  ];
}
