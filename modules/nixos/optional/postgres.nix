{pkgs, ...}: {
  services.postgresql = {
    enable = true;

    package = pkgs.postgresql_14;

    extraPlugins = with pkgs.postgresql_14.pkgs; [
      pgvector
    ];

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

  environment.persistence."/persist".directories = ["/var/lib/postgresql"];
}
