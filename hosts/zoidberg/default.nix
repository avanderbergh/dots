{
  config,
  inputs,
  ...
}: let
  inherit (config.flake.modules) nixos;
in {
  dots = {
    hostConfigs.zoidberg = {
      monitors."eDP-1-1" = config.dots.desktops;
      sshPublicKeyFile = inputs.self + /hosts/zoidberg/ssh_host_ed25519_key.pub;
    };

    nixosHosts.zoidberg.modules = [
      nixos.base
      nixos."host-zoidberg"
    ];
  };
}
