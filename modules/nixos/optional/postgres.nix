{
  pkgs,
  lib,
  ...
}: {
  services = {
    postgresql = {
      enable = true;

      package = pkgs.postgresql_14;

      extraPlugins = with pkgs.postgresql_14.pkgs; [
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
    };

    syslogd.extraConfig = {
      "local0.*" = "/var/log/postgresql";
    };
  };

  environment.persistence."/persist".directories = ["/var/lib/postgresql"];
}
