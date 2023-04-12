{inputs, ...}: {
  imports = [./global ./features/desktop];

  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-mocha;
}
