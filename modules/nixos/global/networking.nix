{lib, ...}: {
  networking = {
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    firewall = {
      enable = true;
      allowedTCPPorts = [22 80 443 9090];
      allowedTCPPortRanges = [
        {
          from = 3000;
          to = 3010;
        }
      ];
    };
  };
}
