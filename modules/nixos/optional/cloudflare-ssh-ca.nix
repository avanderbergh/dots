_: {
  services.openssh.settings = {
    PubkeyAuthentication = true;
    TrustedUserCAKeys = "/var/lib/ssh-ca/cloudflare-ca.pub";
    AuthorizedPrincipalsFile = "/var/lib/ssh-ca/auth_principals/%u";
  };

  system.activationScripts.cloudflareSshCa = {
    text = ''
      mkdir -p /var/lib/ssh-ca/auth_principals
      chmod 0755 /var/lib/ssh-ca
      chmod 0755 /var/lib/ssh-ca/auth_principals

      cat > /var/lib/ssh-ca/cloudflare-ca.pub <<'EOF'
      ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBOzn7HAZE/Kq/O3pTUlvIZHUI4NV47iKW+rlbfZfCzxY24cN4AAEFFBdV1RuG/Zi/6SKoVnvtBjElI1hT5buHFY= open-ssh-ca@cloudflareaccess.org
      EOF
      chmod 0644 /var/lib/ssh-ca/cloudflare-ca.pub

      cat > /var/lib/ssh-ca/auth_principals/avanderbergh <<'EOF'
      avanderbergh
      adriaan
      EOF
      chmod 0644 /var/lib/ssh-ca/auth_principals/avanderbergh
    '';
  };
}
