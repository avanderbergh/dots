{
  pkgs,
  lib,
  ...
}: let
  buildDeps = with pkgs; [
    bzip2
    libffi
    ncurses
    openssl
    readline
    sqlite
    xz
    zlib
  ];

  devPkgs = map lib.getDev buildDeps;

  includeFlags = lib.concatStringsSep " " (map (p: "-I${lib.getDev p}/include") buildDeps);
  libFlags = lib.concatStringsSep " " (map (p: "-L${lib.getLib p}/lib") buildDeps);
  rpathFlags = lib.concatStringsSep " " (map (p: "-Wl,-rpath,${lib.getLib p}/lib") buildDeps);
in {
  home = {
    packages =
      (with pkgs; [
        curl
        gcc
        gnumake
        gnupg
        pkg-config
        python3
      ])
      ++ buildDeps;

    sessionVariables = {
      # Helps mise/asdf plugins compile toolchains on NixOS (pyenv/python-build, node-build, etc.).
      CFLAGS = includeFlags;
      CPPFLAGS = includeFlags;
      LDFLAGS = "${libFlags} ${rpathFlags}";
      PKG_CONFIG_PATH = lib.concatStringsSep ":" [
        (lib.makeSearchPath "lib/pkgconfig" devPkgs)
        (lib.makeSearchPath "share/pkgconfig" devPkgs)
      ];
    };
  };
}
