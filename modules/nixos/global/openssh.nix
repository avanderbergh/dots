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
    # require public key authentication for better security
    settings = {
      # Harden
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      # Automatically remove stale sockets
      StreamLocalBindUnlink = "yes";
      # Allow forwarding ports to everywhere
      GatewayPorts = "clientspecified";
      # Allow SSH agent forwarding
      AllowAgentForwarding = true;
      # Enable X11 forwarding on the server
      X11Forwarding = true;
    };

    hostKeys = [
      {
        path = "${lib.optionalString hasOptinPersistence "/persist"}/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
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
