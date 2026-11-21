{
  flake.modules.nixos.ollama = {
    lib,
    pkgs,
    ...
  }: {
    services.ollama = {
      enable = true;
      package = pkgs.ollama-cuda;
      user = "ollama";
      group = "ollama";
    };

    # Use a static system user and /var/lib/ollama directly so impermanence
    # does not bind-mount inside systemd's /var/lib/private directory.
    systemd.services.ollama.serviceConfig.DynamicUser = lib.mkForce false;

    environment.persistence."/persist".directories = [
      {
        directory = "/var/lib/ollama";
        user = "ollama";
        group = "ollama";
        mode = "0700";
      }
    ];
  };
}
