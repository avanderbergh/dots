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
  };
}
