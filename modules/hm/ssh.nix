{
  config,
  lib,
  ...
}: {
  home.activation.sshConfigPermissions = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ -e "$HOME/.ssh" ] && [ -w "$HOME/.ssh" ]; then
      chmod 700 "$HOME/.ssh"
    fi

    if [ -e "$HOME/.ssh/config" ] && [ -w "$HOME/.ssh/config" ]; then
      chmod 600 "$HOME/.ssh/config"
    fi
  '';

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "*" = {
        forwardAgent = false;
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
        forwardAgent = true;
        forwardX11 = true;
        forwardX11Trusted = true;
      };
      "zoidberg" = {
        hostname = "zoidberg";
        forwardAgent = true;
        forwardX11 = true;
        forwardX11Trusted = true;
      };
    };
  };
}
