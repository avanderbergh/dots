{
  services.openssh.settings = {
    PubkeyAuthentication = true;
    TrustedUserCAKeys = "/etc/ssh/cloudflare-ca.pub";
    AuthorizedPrincipalsFile = "/etc/ssh/auth_principals/%u";
  };

  environment.etc = {
    "ssh/cloudflare-ca.pub".text = ''
      ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBOzn7HAZE/Kq/O3pTUlvIZHUI4NV47iKW+rlbfZfCzxY24cN4AAEFFBdV1RuG/Zi/6SKoVnvtBjElI1hT5buHFY= open-ssh-ca@cloudflareaccess.org
    '';

    "ssh/auth_principals/avanderbergh".text = ''
      avanderbergh
    '';
  };
}
