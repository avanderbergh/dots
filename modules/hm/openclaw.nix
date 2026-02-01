{
  config,
  lib,
  pkgs,
  ...
}: let
  telegramTokenPath = config.sops.secrets.openclaw_telegram_bot_token.path;
  openclawEnvFile = config.sops.templates.openclaw-env.path;

  # Workaround for nix-openclaw#35: gateway.mode/bind don't serialize
  # The Nix type definitions are broken, so we use openclaw CLI to set them
  gatewaySetupScript = pkgs.writeShellScript "openclaw-gateway-setup" ''
    openclaw="${pkgs.openclaw-gateway}/bin/openclaw"

    $openclaw config set gateway.mode local 2>/dev/null || true
    $openclaw config set gateway.bind loopback 2>/dev/null || true

    current_token=$($openclaw config get gateway.auth.token 2>/dev/null || echo "")
    if [ -z "$current_token" ] || [ "$current_token" = "null" ]; then
      new_token=$(cat /proc/sys/kernel/random/uuid | tr -d '-')
      $openclaw config set gateway.auth.token "$new_token" 2>/dev/null || true
    fi
  '';
in {
  sops.templates.openclaw-env = {
    content = ''
      OPENCLAW_GATEWAY_TOKEN=${config.sops.placeholder.openclaw_auth_token}
    '';
  };

  programs.openclaw = {
    exposePluginPackages = false;
    toolNames = [
      "jq"
      "ffmpeg"
      "ripgrep"
    ];

    firstParty = {
      summarize.enable = true;
      oracle.enable = true;
    };

    instances.default = {
      enable = true;
      config = {
        gateway.port = 18789;
        # gateway.mode = "local"; # Cannot set due to upstream type bug - patched via activation hook

        env.vars.OLLAMA_API_KEY = "ollama-local";

        agents.defaults.model.primary = "ollama/gemma3";

        channels.telegram = {
          tokenFile = telegramTokenPath;
          allowFrom = [120043384];
        };
      };
    };
  };

  systemd.user.services.openclaw-gateway = lib.mkIf config.programs.openclaw.instances.default.enable {
    Service = {
      EnvironmentFile = openclawEnvFile;
      # Workaround for nix-openclaw#35: Set gateway.mode and gateway.bind before start
      ExecStartPre = "+${gatewaySetupScript}";
    };
  };
}
