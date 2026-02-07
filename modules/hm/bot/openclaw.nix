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
        model.primary = "openai-codex/gpt-5.3-codex";
        workspace = "/home/morbo";
        maxConcurrent = 4;
        subagents.maxConcurrent = 8;
      };

      channels.telegram = {
        enabled = true;
        dmPolicy = "pairing";
        groupPolicy = "allowlist";
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

      messages.ackReactionScope = "group-mentions";
      plugins.entries.telegram.enabled = true;
      skills.install.nodeManager = "pnpm";
    };
  };
}
