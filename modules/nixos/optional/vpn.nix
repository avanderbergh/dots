{pkgs, ...}: {
  services.tailscale = {
    enable = true;
    openFirewall = true;
    useRoutingFeatures = "client";
  };

  environment.systemPackages = with pkgs; [
    protonvpn-gui
    tailscale
    wireguard-tools
  ];

  networking.firewall = {
    checkReversePath = "loose";
    trustedInterfaces = ["tailscale0"];
  };

  networking.nameservers = [
    "100.100.100.100"
    "1.1.1.1"
    "8.8.8.8"
  ];
}
