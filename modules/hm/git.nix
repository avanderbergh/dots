{pkgs, ...}: {
  programs.git = {
    enable = true;
    lfs.enable = true;
    userEmail = "avanderbergh@gmail.com";
    userName = "Adriaan van der Bergh";
    extraConfig = {
      core.editor = "code --wait";
      init.defaultBranch = "main";
    };
    signing = {
      key = "741E DA0A 1F94 2978 D0E6  12ED 9380 36D7 4671 D8D5";
      signByDefault = true;
    };
  };

  home = {
    packages = with pkgs; [
      ghq
    ];
    sessionVariables = {
      GHQ_ROOT = "/home/avanderbergh/repos";
    };
  };
}
