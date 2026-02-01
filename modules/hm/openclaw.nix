{config, ...}: let
  telegramTokenPath = config.sops.secrets.openclaw_telegram_bot_token.path;
  openclawEnvFile = config.sops.templates.openclaw-env.path;
in {
  sops.templates.openclaw-env = {
    content = ''
      OPENCLAW_GATEWAY_TOKEN=${config.sops.secrets.openclaw_auth_token.placeholder}
    '';
  };

  systemd.user.services.openclaw-gateway.Service.EnvironmentFile = openclawEnvFile;

  programs.openclaw = {
    enable = true;
    exposePluginPackages = false;
    toolNames = [
      "jq"
      "ffmpeg"
      "ripgrep"
    ];

    config = {
      gateway = {
        mode = "local";
        auth.mode = "token";
      };

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

    firstParty = {
      summarize.enable = true;
      oracle.enable = true;
    };

    instances.default.enable = true;
  };
}
