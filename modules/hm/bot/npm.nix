{config, ...}: let
  npmPrefix = "${config.home.homeDirectory}/.local/share/npm";
  pnpmHome = "${config.home.homeDirectory}/.local/share/pnpm";
in {
  home = {
    sessionVariables = {
      NPM_CONFIG_PREFIX = npmPrefix;
      PNPM_HOME = pnpmHome;
    };

    sessionPath = [
      pnpmHome
      "${npmPrefix}/bin"
    ];
  };
}
