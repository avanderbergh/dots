{pkgs, ...}: {
  services.fprintd = {
    enable = true;
    tod = {
      enable = true;
      driver = pkgs.libfprint-2-tod1-goodix;
    };
  };

  security.pam.services = {
    login.fprintAuth = true;
    i3lock = {
      fprintAuth = true;
      text = ''
        auth sufficient pam_unix.so try_first_pass likeauth nullok
        auth sufficient pam_fprintd.so
      '';
    };
  };

  environment.persistence."/persist".directories = ["/var/lib/fprint"];
}
