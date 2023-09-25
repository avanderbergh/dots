{pkgs, ...}: {
  environment.systemPackages = with pkgs; [AusweisApp2];
  networking.firewall = {
    allowedTCPPorts = [24727];
    allowedUDPPorts = [24727];
  };
}
