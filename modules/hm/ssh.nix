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

    extraConfig = ''
      AddKeysToAgent yes
    '';
  };
}
