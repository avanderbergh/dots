{
  programs.autorandr = {
    enable = true;
    profiles = {
      "fc" = {};
      "mobile" = {};
    };
  };

  services.autorandr.enable = true;
}
