{config, ...}: {
  sops.secrets.ssh = {
    key = "morbo/ssh";
  };

  programs.ssh.matchBlocks."*" = {
    identityFile = [config.sops.secrets.ssh.path];
  };
}
