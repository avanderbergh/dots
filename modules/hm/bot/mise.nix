{pkgs, ...}: {
  programs.mise = {
    enable = true;
    enableBashIntegration = true;
    package = pkgs.mise;
    globalConfig = {
      settings = {
        # On NixOS, prefer prebuilt tools where available. This avoids slow source builds
        # and works well with `nix-ld` + `envfs` for FHS-compiled binaries.
        all_compile = false;

        node.compile = false;

        # The python plugin commonly compiles from source on Linux; keep it enabled by default.
        python.compile = true;
      };
    };
  };
}
