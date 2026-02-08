{
  config,
  lib,
  outputs,
  ...
}: let
  inherit (config.networking) hostName;
  hosts = outputs.nixosConfigurations;
  pubKey = host: ../../../hosts/${host}/ssh_host_ed25519_key.pub;

  hasOptinPersistence = lib.hasAttrByPath ["environment" "persistence"] config;
in {
  services.openssh = {
    enable = true;
    extraConfig = ''
      Match User avanderbergh
        AllowAgentForwarding yes
    '';
    # require public key authentication for better security
    settings = {
      # Harden
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      # Automatically remove stale sockets
      StreamLocalBindUnlink = "yes";
      # Deny SSH agent forwarding by default (least privilege)
      AllowAgentForwarding = false;
    };

    hostKeys = [
      {
        path = "${lib.optionalString hasOptinPersistence "/persist"}/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
      {
        path = "${lib.optionalString hasOptinPersistence "/persist"}/etc/ssh/ssh_host_ecdsa_key";
        type = "ecdsa";
      }
    ];
  };

  programs.ssh = {
    # Each hosts public key
    knownHosts =
      builtins.mapAttrs
      (name: _: {
        publicKeyFile = pubKey name;
        extraHostNames = lib.optional (name == hostName) "localhost";
      })
      hosts;
  };
}
