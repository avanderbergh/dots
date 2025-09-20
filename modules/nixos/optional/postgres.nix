{
  pkgs-stable,
  lib,
  config,
  ...
}: {
  services = {
    postgresql = {
      enable = true;

      package = pkgs-stable.postgresql_17;

      extensions = with pkgs-stable.postgresql_17.pkgs; [
        pgvector
      ];

      settings = {
        log_connections = true;
        log_statement = "all";
        logging_collector = true;
        log_disconnections = true;
        # log_destination = lib.mkForce "syslog";
      };

      authentication = ''
        local all   postgres      peer    map=eroot
        local all   avanderbergh  peer
        local all   all           md5
      '';

      identMap = ''
        eroot     root      postgres
        eroot     postgres  postgres
      '';

      ensureUsers = [
        {
          name = "avanderbergh";
          ensureClauses = {
            superuser = true;
            createrole = true;
            createdb = true;
          };
        }
      ];
    };

    syslogd.extraConfig = {
      "local0.*" = "/var/log/postgresql";
    };
  };

  environment.persistence."/persist".directories = ["/var/lib/postgresql"];
}
