{
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    secrets = {
      openclaw_telegram_bot_token = {};
      openclaw_auth_token = {};
    };
  };
}
