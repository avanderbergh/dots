{
  config,
  lib,
  pkgs,
  ...
}: {
  services.github-runners.q15 = {
    enable = true;
    url = "https://github.com/q15co";
    tokenFile = config.sops.secrets.github-runner-hermes.path;
    name = "hermes-q15";
    extraLabels = ["nixos" "linux-x64" "q15"];
    extraPackages = with pkgs; [
      nix
      nix-prefetch-git
      git
      git-crypt
      jq
      curl
      gnused
      gnugrep
      coreutils
      devenv
    ];
    user = "morbo";
    group = "morbo";
    # Ephemeral runners get a fresh state on each job - cleaner for CI
    ephemeral = true;
  };

  sops.secrets.github-runner-hermes = {
    key = "github/hermes-runner";
    owner = "morbo";
    group = "morbo";
    mode = "0400";
  };
}
