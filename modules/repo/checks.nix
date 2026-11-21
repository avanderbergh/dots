{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    formatter = pkgs.alejandra;

    checks = {
      formatting =
        pkgs.runCommand "check-formatting" {
          nativeBuildInputs = [pkgs.alejandra];
        } ''
          alejandra --check ${inputs.self}
          touch "$out"
        '';

      statix =
        pkgs.runCommand "check-statix" {
          nativeBuildInputs = [pkgs.statix];
        } ''
          statix check --format errfmt ${inputs.self}
          touch "$out"
        '';
    };
  };
}
