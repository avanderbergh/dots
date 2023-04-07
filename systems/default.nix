{ withSystem, inputs, ... }:
let 
  inherit (inputs.nixpkgs.lib) nixosSystem;
in {
  flake.nixosConfigurations = withSystem "x86_64-linux" ({system, ...}: {
    zoidberg = nixosSystem {
      inherit system;

      modules = [
        inputs.hyprland.nixosModules.default
        inputs.impermanence.nixosModules.impermanence
        ./modules/impermanence.nix
        # inputs.lanzaboote.nixosModules.lanzaboote
        # ./msecureboot.nix
        ./shared.nix
        ./zoidberg.nix
      ];
    };
  });
}