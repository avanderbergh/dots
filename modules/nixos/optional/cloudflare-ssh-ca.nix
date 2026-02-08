_: {
  services.openssh.settings = {
    TrustedUserCAKeys = "/etc/ssh/cloudflare-ca.pub";
    AuthorizedPrincipalsFile = "/etc/ssh/auth_principals/%u";
  };

  environment.etc = {
    "ssh/cloudflare-ca.pub".text = ''
      ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBOoH1YnxoMoB3xrNFtEQViG371+sc1VCNHmumB6D+QvvX9Cnrzu2zMg/FO9AvXd28LlKPUeC3Fhshuq9BfvCa+0= open-ssh-ca@cloudflareaccess.org
    '';

    "ssh/auth_principals/avanderbergh".text = ''
      avanderbergh
    '';
  };
}
