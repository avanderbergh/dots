{config, ...}: let
  telegramTokenPath = config.sops.secrets.openclaw_telegram_bot_token.path;
  openclawEnvFile = config.sops.templates.openclaw-env.path;
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
        env = {
          vars = {
            OLLAMA_API_KEY = "ollama-local";
          };
        };

        agents = {
          defaults = {
            model = {
              primary = "ollama/gemma3";
            };
          };
        };

        channels.telegram = {
          tokenFile = telegramTokenPath;
          allowFrom = [120043384];
        };
      };
    };
  };

  systemd.user.services.openclaw-gateway.Service.EnvironmentFile = openclawEnvFile;
}
