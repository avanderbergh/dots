{config, ...}: let
  telegramTokenPath = config.sops.secrets.openclaw_telegram_bot_token.path;
in {
  programs.openclaw = {
    enable = true;
    toolNames = [
      "nodejs_22"
      "pnpm_10"
      "git"
      "curl"
      "jq"
      "ffmpeg"
      "ripgrep"
    ];

    config = {
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
