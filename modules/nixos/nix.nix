{
  flake.modules.nixos.nix = {
    config,
    lib,
    ...
  }: {
    nix = {
      settings = {
        experimental-features = ["nix-command" "flakes"];
        substituters =
          lib.optionals (config.networking.hostName != "hermes") [
            "http://hermes:5000"
          ]
          ++ [
            "https://cache.nixos.org"
            "https://nix-community.cachix.org"
          ];
        trusted-public-keys = [
          "hermes:ctaxZAzCtUCIsQCwrws97n2o81DIPM9c1iXUO3H59U8="
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
        trusted-users = ["root" config.local.users.ownerName];
        connect-timeout = 5;
        download-buffer-size = 134217728;
      };
      optimise = {
        automatic = true;
        dates = ["Sun 04:30"];
      };
    };
    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep 5 --keep-since 3d";
      };
    };
  };
}
