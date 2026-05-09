{
  config,
  inputs,
  ...
}: let
  inherit (config.flake.modules) nixos;
in {
  dots = {
    hostConfigs.farnsworth = {
      sshPublicKeyFile = inputs.self + /hosts/farnsworth/ssh_host_ed25519_key.pub;
    };

    nixosHosts.farnsworth = {
      enableHomeManager = false;
      modules = [
        nixos.base
        nixos."host-farnsworth"
      ];
    };
  };
}
