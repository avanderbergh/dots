{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    protonvpn-gui
    wireguard-tools
  ];

  networking = {
    firewall = {
      checkReversePath = false;
    };
  };
}
