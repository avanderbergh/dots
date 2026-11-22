{config, ...}: let
  inherit (config.dots) ownerGitSigningKey ownerSshKeys;
in {
  flake.modules.homeManager."profile-git" = {
    config,
    lib,
    pkgs,
    ...
  }: let
    allowedSignersFile = pkgs.writeText "git-allowed-signers" (
      lib.concatMapStrings (key: "avanderbergh@gmail.com ${key}\n") ownerSshKeys
    );
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
        key = "key::${ownerGitSigningKey}";
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
