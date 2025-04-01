{
  services = {
    ollama = {
      enable = true;
      acceleration = "cuda";
      openFirewall = true;
    };
    open-webui = {
      enable = true;
      port = 11111;
      openFirewall = true;
      host = "0.0.0.0";
      # Add environment variable to fix home directory issue
      environment = {
        HOME = "/var/lib/private/open-webui";
      };
    };
  };

  environment.persistence."/persist" = {
    directories = [
      {
        directory = "/var/lib/private/ollama";
        user = "nobody";
        group = "nogroup";
        mode = "0755";
      }
      {
        directory = "/var/lib/private/open-webui";
        user = "nobody";
        group = "nogroup";
        mode = "0755";
      }
    ];
  };
}
