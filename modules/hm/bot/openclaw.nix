{pkgs, ...}: {
  local.openclaw = {
    enable = true;
    package = pkgs.openclaw-gateway;
    gatewayPort = 18789;
    seedFromBackup = true;
    mutablePaths = [
      "meta"
      "wizard"
      "auth.profiles"
      "agents"
      "skills.entries"
      "plugins.entries"
      "messages"
      "commands"
    ];

    # Secrets stay out of repo config and are injected via /run/secrets files.
    baseConfig = {
      agents.defaults = {
        model = {
          primary = "openai-codex/gpt-5.3-codex";
          fallbacks = [
            "google/gemini-3-pro-preview"
            "google/gemini-3-flash-preview"
          ];
        };
        models = {
          "google/gemini-3-pro-preview".alias = "gemini";
          "google/gemini-3-flash-preview".alias = "gemini-flash";
          "openai-codex/gpt-5.3-codex" = {};
        };
        workspace = "/home/morbo";
        maxConcurrent = 4;
        subagents.maxConcurrent = 8;
      };

      channels.telegram = {
        enabled = true;
        dmPolicy = "pairing";
        groupPolicy = "allowlist";
        groups."-1003794257231" = {
          enabled = true;
          groupPolicy = "open";
          requireMention = false;
        };
        streamMode = "partial";
      };

      commands = {
        native = "auto";
        nativeSkills = "auto";
      };

      gateway = {
        mode = "local";
        bind = "loopback";
        tailscale = {
          mode = "off";
          resetOnExit = false;
        };
        auth = {
          mode = "token";
          allowTailscale = true;
        };
      };

      messages = {
        ackReactionScope = "group-mentions";
        tts = {
          provider = "edge";
          edge = {
            enabled = true;
            voice = "en-US-GuyNeural";
            lang = "en-US";
            outputFormat = "ogg-24khz-16bit-mono-opus";
            pitch = "-22%";
            rate = "-8%";
          };
        };
      };
      plugins.entries.telegram.enabled = true;
      skills.install.nodeManager = "pnpm";
    };
  };
}
