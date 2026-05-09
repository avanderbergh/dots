{
  config,
  inputs,
  ...
}: let
  nixpkgsArgs = {
    inherit (config.dots) system;
    config = {
      allowUnfree = true;
      allowCuda = true;
    };
    overlays = [
      (import (inputs.self + /pkgs))
    ];
  };

  mkPkgs = nixpkgsSource: import nixpkgsSource nixpkgsArgs;
in {
  dots = {
    inherit nixpkgsArgs;

    packageSets = {
      pkgs = mkPkgs inputs.nixpkgs;
      pkgs-stable = mkPkgs inputs.nixpkgs-stable;
      pkgs-master = mkPkgs inputs.nixpkgs-master;
    };
  };
}
