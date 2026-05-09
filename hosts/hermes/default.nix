{
  config,
  inputs,
  ...
}: let
  inherit (config.flake.modules) nixos;
in {
  dots = {
    hostConfigs.hermes = {
      monitors."DP-0" = config.dots.desktops;
      sshPublicKeyFile = inputs.self + /hosts/hermes/ssh_host_ed25519_key.pub;
    };

    nixosHosts.hermes.modules = [
      nixos.base
      nixos."host-hermes"
    ];
  };
}
