{config, ...}: let
  hm = config.flake.modules.homeManager;

  shared = [
    hm."integration-sops"
    hm."user-avanderbergh"
    hm."profile-console"
    hm."profile-git"
    hm."profile-node"
    hm."profile-go"
    hm."profile-python"
    hm."profile-dev"
    hm."profile-sops"
    hm."profile-syncthing"
    hm."profile-ssh"
  ];
in {
  dots = {
    homeModules = {
      "avanderbergh@zoidberg" =
        shared
        ++ [
          hm."profile-desktop-apps"
          hm."profile-desktop"
        ];

      "avanderbergh@hermes" =
        shared
        ++ [
          hm."profile-q15"
        ];

      "morbo@hermes" = [
        hm."user-morbo"
        hm."profile-dev"
        hm."profile-bot"
        hm."profile-ssh"
      ];
    };

    standaloneHomeModules = {
      "avanderbergh@zoidberg" = [
        hm."integration-zoidberg-desktop"
      ];
    };
  };
}
