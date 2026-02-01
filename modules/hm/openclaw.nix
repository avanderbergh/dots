{
  config,
  lib,
  pkgs,
  ...
}: let
  telegramTokenPath = config.sops.secrets.openclaw_telegram_bot_token.path;
  openclawEnvFile = config.sops.templates.openclaw-env.path;

  # Workaround for upstream type bug in nix-openclaw (#github.com/openclaw/nix-openclaw)
  # gateway.mode type is incorrectly defined as:
  # t.oneOf [ (t.enum [ "local" ]) (t.enum [ "remote" ]) ]
  # This causes "expected a set but found a function" error during evaluation
  #
  # Solution: Post-process the generated JSON config to inject gateway.mode
  # This completely bypasses the buggy type checking
  patchedConfigHook = ''
    # Inject gateway.mode into config JSON after generation
    configPath="$HOME/.openclaw/openclaw.json"
    if [ -f "$configPath" ]; then
      ${pkgs.jq}/bin/jq '.gateway.mode = "local"' "$configPath" > "$configPath.tmp"
      mv "$configPath.tmp" "$configPath"
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

  systemd.user.services.openclaw-gateway-default = lib.mkIf config.programs.openclaw.instances.default.enable {
    Service.EnvironmentFile = openclawEnvFile;
  };

  # Post-process config to inject gateway.mode (workaround for type bug)
  home.activation.openclawConfigPatch = lib.hm.dag.entryAfter ["openclawConfigFiles"] patchedConfigHook;
}
