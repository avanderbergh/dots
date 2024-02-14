{
  services.syncthing = {
    enable = true;
    extraOptions = [
      "--no-upgrade"
      "--config=/home/avanderbergh/.config/syncthing"
      "--data=/home/avanderbergh/sync"
    ];
  };
}
