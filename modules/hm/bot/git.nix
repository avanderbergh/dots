{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      init.defaultBranch = "main";
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
}
