{
  config,
  ...
}: let
  isAvanderbergh = config.home.username == "avanderbergh";
in {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "*" = {
        forwardAgent = false;
        forwardX11 = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        compression = false;
        addKeysToAgent = "yes";
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
      "hermes" = {
        hostname = "hermes";
        forwardAgent = isAvanderbergh;
        forwardX11 = false;
      };
      "zoidberg" = {
        hostname = "zoidberg";
        forwardAgent = isAvanderbergh;
        forwardX11 = false;
      };
    };
  };
}
