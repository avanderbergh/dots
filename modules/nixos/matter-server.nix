{
  flake.modules.nixos.matter-server = {
    services.matter-server = {
      enable = true;
      openFirewall = true;
    };
  };
}
