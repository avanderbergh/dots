{pkgs, ...}: {
  services.postgresql = {
    enable = true;

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
