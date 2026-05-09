{config, ...}: let
  hm = config.flake.modules.homeManager;
in {
  flake.modules.homeManager."profile-bot" = {
    imports = [
      hm."profile-go"
      hm."profile-bot-git"
      hm."profile-bot-npm"
      hm."profile-bot-tools"
    ];
  };
}
