{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs.q15.packages.${pkgs.system}) q15;
  containerHelperBins = pkgs.symlinkJoin {
    name = "q15-container-helpers";
    paths = [pkgs.netavark pkgs.aardvark-dns];
  };
  q15ConfigDir = "${config.home.homeDirectory}/.config/q15";
  q15RuntimePath = lib.makeBinPath [
    q15
    pkgs.aardvark-dns
    pkgs.bash
    pkgs.buildah
    pkgs.coreutils
    pkgs.git
    pkgs.nix
    pkgs.netavark
  ];
in {
  home.packages = [
    q15
    pkgs.aardvark-dns
    pkgs.buildah
    pkgs.netavark
  ];

  home.activation.q15ConfigDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run mkdir -p ${lib.escapeShellArg q15ConfigDir}
    run chmod 700 ${lib.escapeShellArg q15ConfigDir}
  '';

  sops.secrets.q15_env = {
    mode = "0400";
    path = "${q15ConfigDir}/q15.env";
  };

  systemd.user.services.q15 = {
    Unit = {
      Description = "q15 agent harness";
      Wants = ["network-online.target"];
      After = ["network-online.target" "sops-nix.service"];
    };

    Service = {
      Type = "simple";
      Environment = [
        "CONTAINERS_HELPER_BINARY_DIR=${containerHelperBins}/bin"
        "PATH=/run/wrappers/bin:/run/current-system/sw/bin:${q15RuntimePath}:/etc/profiles/per-user/${config.home.username}/bin"
      ];
      EnvironmentFile = "-${config.sops.secrets.q15_env.path}";
      ExecStart = "${q15}/bin/q15 start";
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install.WantedBy = ["default.target"];
  };
}
