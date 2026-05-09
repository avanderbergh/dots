{
  flake.modules.nixos."host-hermes" = {
    lib,
    pkgs,
    ...
  }: {
    services.envfs.enable = true;

    programs.nix-ld.libraries = lib.mkAfter (with pkgs; [
      bzip2
      libffi
      ncurses
      openssl
      readline
      sqlite
      xz
      zlib
    ]);
  };
}
