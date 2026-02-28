{config, ...}: {
  services.syncthing = {
    enable = true;
    extraOptions = [
      "--no-upgrade"
      "--config=${config.home.homeDirectory}/.config/syncthing"
      "--data=${config.home.homeDirectory}/sync"
    ];
  };
}
