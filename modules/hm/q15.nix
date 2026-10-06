{
  flake.modules.homeManager."profile-q15" = {
    config,
    lib,
    pkgs,
    ...
  }: let
    q15ConfigDir = "${config.home.homeDirectory}/.config/q15";
    q15AuthDir = "${q15ConfigDir}/auth";
  in {
    home.packages = [
      pkgs.q15-auth
      pkgs.podman
    ];

    home.activation.q15Directories = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run mkdir -p ${lib.escapeShellArg q15ConfigDir}
      run mkdir -p ${lib.escapeShellArg q15AuthDir}

      run chmod 700 ${lib.escapeShellArg q15ConfigDir}
      run chmod 700 ${lib.escapeShellArg q15AuthDir}
    '';
  };
}
