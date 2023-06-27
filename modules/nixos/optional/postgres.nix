{
  services.postgresql = {
    enable = true;

    authentication = ''
      local all   postgres       peer map=eroot
    '';

    identMap = ''
      eroot     root      postgres
      eroot     postgres  postgres
    '';
  };
}
