{config, ...}: let
  inherit (config.dots) ownerSshKey;
in {
  flake.modules.homeManager."profile-git" = {
    config,
    lib,
    pkgs,
    ...
  }: let
    allowedSignersFile = pkgs.writeText "git-allowed-signers" ''
      avanderbergh@gmail.com ${ownerSshKey}
    '';
  in {
    programs.git = {
      enable = true;
      lfs.enable = true;
      settings = {
        user = {
          email = "avanderbergh@gmail.com";
          name = "Adriaan van der Bergh";
        };
        core.editor = lib.mkDefault "nvim";
        gpg.ssh.allowedSignersFile = "${allowedSignersFile}";
        init.defaultBranch = "main";
      };
      signing = {
        format = "ssh";
        key = "key::${ownerSshKey}";
        signByDefault = true;
      };
    };

    home = {
      packages = with pkgs; [
        gh
        ghq
      ];
      sessionVariables = {
        GHQ_ROOT = "${config.home.homeDirectory}/repos";
      };
    };
  };
}
