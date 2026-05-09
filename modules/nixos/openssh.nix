{config, ...}: let
  inherit (config.dots) hostConfigs;
in {
  flake.modules.nixos.openssh = {
    config,
    lib,
    ...
  }: let
    inherit (config.networking) hostName;
    hostsWithPublicKeys = lib.filterAttrs (_: hostConfig: hostConfig ? sshPublicKeyFile) hostConfigs;

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
        # Cloudflare browser-rendered SSH compatibility (reported working setting).
        Macs = ["hmac-sha2-256"];
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
        (name: hostConfig: {
          publicKeyFile = hostConfig.sshPublicKeyFile;
          extraHostNames = lib.optional (name == hostName) "localhost";
        })
        hostsWithPublicKeys;
    };
  };
}
