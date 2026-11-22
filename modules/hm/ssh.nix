{
  flake.modules.homeManager."profile-ssh" = {
    config,
    lib,
    pkgs,
    ...
  }: {
    services.ssh-agent.enable = true;

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      settings = {
        "*" = {
          ForwardAgent = false;
          ForwardX11 = false;
          ServerAliveInterval = 0;
          ServerAliveCountMax = 3;
          Compression = false;
          AddKeysToAgent = "yes";
          IdentityFile = [
            "~/.ssh/id_ed25519_sk_primary"
            "~/.ssh/id_ed25519_sk_backup"
          ];
          HashKnownHosts = false;
          UserKnownHostsFile = "~/.ssh/known_hosts";
          ControlMaster = "no";
          ControlPath = "~/.ssh/master-%r@%n:%p";
          ControlPersist = "no";
        };
        "hermes" = {
          HostName = "hermes";
          ForwardAgent = true;
          ForwardX11 = false;
        };
        "zoidberg" = {
          HostName = "zoidberg";
          ForwardAgent = true;
          ForwardX11 = false;
        };
      };
    };

    # Sandboxed FHS apps (such as pkgs.vscode.fhs via bwrap) see root-owned
    # /nix/store symlinks as nobody (65534), causing OpenSSH to reject
    # ~/.ssh/config with "Bad owner or permissions". Materialize a regular
    # user-owned 0600 file at ~/.ssh/config from the generated config.
    home.file.".ssh/config".target = ".ssh/config_source";

    home.activation.materializeSshConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run ${pkgs.coreutils}/bin/rm -f "${config.home.homeDirectory}/.ssh/config"
      run ${pkgs.coreutils}/bin/install -m 0600 "${config.home.homeDirectory}/.ssh/config_source" "${config.home.homeDirectory}/.ssh/config"
    '';

    # Pre-load local non-secret FIDO2 key handle stubs into ssh-agent on login
    # so terminal Git, SSH, and VS Code work right after boot with just a YubiKey touch.
    systemd.user.services.ssh-agent-load-keys = {
      Unit = {
        Description = "Load local FIDO2 SSH key handles into ssh-agent";
        After = ["ssh-agent.service"];
        PartOf = ["ssh-agent.service"];
      };
      Service = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "ssh-agent-load-keys" ''
          export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/${config.services.ssh-agent.socket}"
          export SSH_ASKPASS_REQUIRE=never

          for _ in $(${pkgs.coreutils}/bin/seq 1 100); do
            [ -S "$SSH_AUTH_SOCK" ] && break
            ${pkgs.coreutils}/bin/sleep 0.05
          done

          load_key() {
            [ -f "$1" ] || return 0
            ${lib.getExe' config.services.ssh-agent.package "ssh-add"} "$1" < /dev/null || true
          }

          # Prefer the primary handle first so SSH tries it before backup keys.
          load_key "${config.home.homeDirectory}/.ssh/id_ed25519_sk_primary"
          for key in "${config.home.homeDirectory}"/.ssh/id_ed25519_sk*; do
            case "$key" in
              *.pub | *"*" | */id_ed25519_sk_primary) continue ;;
            esac
            load_key "$key"
          done
        '';
      };
      Install.WantedBy = [
        "default.target"
        "ssh-agent.service"
      ];
    };
  };
}
