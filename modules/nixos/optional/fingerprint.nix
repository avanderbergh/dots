{pkgs, ...}: {
  services.fprintd = {
    enable = true;
    tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-goodix;
    };
  };

  environment.persistence."/persist".directories = ["/var/lib/fprint"];
}
