{inputs, ...}: {
  flake.modules.nixos.sops = {
    config,
    pkgs,
    ...
  }: let
    isEd25519 = key: key.type == "ed25519";
    ed25519HostKeys = builtins.filter isEd25519 config.services.openssh.hostKeys;
  in {
    imports = [
      inputs.sops-nix.nixosModules.sops
    ];

    sops = {
      defaultSopsFormat = "yaml";
      defaultSopsFile = inputs.self + /secrets/secrets.yaml;
      age.sshKeyPaths = map (hostKey: hostKey.path) ed25519HostKeys;
      gnupg.sshKeyPaths = [];
    };

    environment.systemPackages = [
      pkgs.sops
    ];
  };

  flake.modules.homeManager."integration-sops" = inputs.sops-nix.homeManagerModules.sops;
}
