{
  withSystem,
  inputs,
  ...
}: let
  inherit (inputs.nixpkgs.lib) nixosSystem;
in {
  flake.nixosConfigurations =
    withSystem "x86_64-linux"
    ({system, ...}: {
      zoidberg = nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [./zoidberg];
      };
    });
}
