{
  config,
  lib,
  ...
}: {
  programs.ssh = {
    enable = true;

    matchBlocks = {
      "hermes" = {
        hostname = "hermes";
        forwardAgent = true;
      };
      "zoidberg" = {
        hostname = "zoidberg";
        forwardAgent = true;
      };
    };

    extraConfig = ''
      AddKeysToAgent yes
    '';
  };
}
