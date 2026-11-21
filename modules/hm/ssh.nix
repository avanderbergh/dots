{
  flake.modules.homeManager."profile-ssh" = _: {
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
