{...}: {
  programs.ssh.matchBlocks."*" = {
    identityFile = ["/run/secrets/morbo-ssh"];
  };
}
