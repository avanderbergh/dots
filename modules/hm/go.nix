{
  flake.modules.homeManager."profile-go" = {
    lib,
    pkgs,
    ...
  }: {
    home.packages = [
      pkgs.go_1_25
      pkgs.gopls
      pkgs.gofumpt
      # gopls also provides modernize; keep the rest of gotools without a buildEnv collision.
      (lib.lowPrio pkgs.gotools)
      pkgs.golangci-lint
      pkgs.golines
      pkgs.gosec
      pkgs.delve
    ];
  };
}
