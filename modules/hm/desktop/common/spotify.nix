{
  inputs,
  pkgs,
  spicetify-nix,
  ...
}: {
  imports = [spicetify-nix.homeManagerModule];

  # themable spotify
  programs.spicetify = let
    spicePkgs = spicetify-nix.packages.${pkgs.system}.default;
  in {
    enable = true;

    theme = spicePkgs.themes.catppuccin;

    colorScheme = "mocha";

    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      history
      genre
      hidePodcasts
      shuffle
    ];
  };
}
