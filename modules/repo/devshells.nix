{
  perSystem = {pkgs, ...}: let
    nixosDotsTools = with pkgs; [
      alejandra
      git
      nix
      ripgrep
      statix
    ];
  in {
    devShells = {
      default = pkgs.mkShell {
        packages = nixosDotsTools;
      };

      "nixos-dots" = pkgs.mkShell {
        packages = nixosDotsTools;
      };
    };
  };
}
