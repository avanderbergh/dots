{
  flake.modules.homeManager."profile-q15" = {
    config,
    lib,
    pkgs,
    ...
  }: let
    q15ConfigDir = "${config.home.homeDirectory}/.config/q15";
    q15StackDir = "${q15ConfigDir}/stacks/jared";
    q15SecretsDir = "${q15ConfigDir}/secrets/jared";
    q15RuntimeDir = "${config.home.homeDirectory}/q15-runtime/jared";
    q15RuntimePath = lib.makeBinPath [
      pkgs.bash
      pkgs.coreutils
      pkgs.findutils
      pkgs.gnugrep
      pkgs.podman
      pkgs.podman-compose
      pkgs.procps
      pkgs.util-linux
    ];
    requiredFiles = [
      "${q15StackDir}/compose.yaml"
      "${q15StackDir}/agent-config.yaml"
      "${q15StackDir}/proxy-policy.yaml"
      "${q15StackDir}/.env"
      "${q15ConfigDir}/auth.json"
    ];
    validateStackFiles = pkgs.writeShellScript "q15-validate-stack-files" ''
      set -euo pipefail

      required_files=(
        ${lib.concatMapStringsSep "\n      " lib.escapeShellArg requiredFiles}
      )

      missing=0
      for required in "''${required_files[@]}"; do
        if [ ! -f "$required" ]; then
          echo "q15: required operator-managed file missing: $required" >&2
          missing=1
        fi
      done

      if [ "$missing" -ne 0 ]; then
        echo "q15: create the operator-managed stack files before starting q15.service" >&2
        exit 1
      fi
    '';
  in {
    home.packages = [
      pkgs.q15-auth
      pkgs.podman
      pkgs.podman-compose
    ];

    home.activation.q15Directories = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run mkdir -p ${lib.escapeShellArg q15ConfigDir}
      run mkdir -p ${lib.escapeShellArg q15StackDir}
      run mkdir -p ${lib.escapeShellArg q15SecretsDir}
      run mkdir -p ${lib.escapeShellArg q15RuntimeDir}
      run mkdir -p ${lib.escapeShellArg "${q15RuntimeDir}/memory"}
      run mkdir -p ${lib.escapeShellArg "${q15RuntimeDir}/nix"}
      run mkdir -p ${lib.escapeShellArg "${q15RuntimeDir}/proxy"}

      run chmod 700 ${lib.escapeShellArg q15ConfigDir}
      run chmod 700 ${lib.escapeShellArg q15StackDir}
      run chmod 700 ${lib.escapeShellArg q15SecretsDir}
      run chmod 700 ${lib.escapeShellArg q15RuntimeDir}
      run chmod 700 ${lib.escapeShellArg "${q15RuntimeDir}/memory"}
      run chmod 700 ${lib.escapeShellArg "${q15RuntimeDir}/nix"}
      run chmod 700 ${lib.escapeShellArg "${q15RuntimeDir}/proxy"}
    '';

    sops = {
      secrets = {
        q15_jared_moonshot_api_key = {
          key = "q15/hermes/jared/moonshot_api_key";
          mode = "0400";
          path = "${q15SecretsDir}/moonshot_api_key";
        };

        q15_jared_zai_api_key = {
          key = "q15/hermes/jared/zai_api_key";
          mode = "0400";
          path = "${q15SecretsDir}/zai_api_key";
        };

        q15_jared_q15_telegram_token = {
          key = "q15/hermes/jared/q15_telegram_token";
          mode = "0400";
          path = "${q15SecretsDir}/q15_telegram_token";
        };

        q15_jared_github_token = {
          key = "q15/hermes/jared/github_token";
          mode = "0400";
          path = "${q15SecretsDir}/github_token";
        };

        q15_jared_annas_secret_key = {
          key = "q15/hermes/jared/annas_secret_key";
          mode = "0400";
          path = "${q15SecretsDir}/annas_secret_key";
        };

        q15_jared_brave_api_key = {
          key = "q15/hermes/jared/brave_api_key";
          mode = "0400";
          path = "${q15SecretsDir}/brave_api_key";
        };

        q15_jared_fal_key = {
          key = "q15/hermes/jared/fal_key";
          mode = "0400";
          path = "${q15SecretsDir}/fal_key";
        };

        q15_jared_gemini_api_key = {
          key = "q15/hermes/jared/gemini_api_key";
          mode = "0400";
          path = "${q15SecretsDir}/gemini_api_key";
        };
      };
    };

    systemd.user.services.q15 = {
      Unit = {
        Description = "q15 agent stack";
        Wants = ["network-online.target" "sops-nix.service"];
        After = ["network-online.target" "sops-nix.service"];
      };

      Service = {
        Type = "oneshot";
        RemainAfterExit = true;
        WorkingDirectory = q15StackDir;
        Environment = [
          "HOME=${config.home.homeDirectory}"
          "PATH=/run/wrappers/bin:/run/current-system/sw/bin:${q15RuntimePath}:/etc/profiles/per-user/${config.home.username}/bin"
        ];
        ExecStartPre = validateStackFiles;
        ExecStart = "${pkgs.podman-compose}/bin/podman-compose up -d --remove-orphans";
        ExecReload = "${pkgs.podman-compose}/bin/podman-compose up -d --remove-orphans";
        ExecStop = "-${pkgs.podman-compose}/bin/podman-compose down";
        TimeoutStartSec = 120;
        TimeoutStopSec = 120;
      };

      Install.WantedBy = ["default.target"];
    };
  };
}
