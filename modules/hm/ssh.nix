{
  flake.modules.homeManager."profile-ssh" = _: {
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
  };
}
