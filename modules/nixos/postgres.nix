{config, ...}: let
  inherit (config.dots.packageSets) pkgs-stable;
in {
  flake.modules.nixos.postgres = {
    services.postgresql = {
      enable = true;
      package = pkgs-stable.postgresql_17;
      enableJIT = true;
      extensions = with pkgs-stable.postgresql_17.pkgs; [
        postgis
      ];
    };

    environment.persistence."/persist".directories = ["/var/lib/postgresql"];
  };
}
