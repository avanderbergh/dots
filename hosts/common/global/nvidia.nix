{
  hardware = {
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      prime.offload.enable = false;
    };

    opengl = {
      driSupport = true;
      driSupport32Bit = true;
      enable = true;
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];
}
