{
  config,
  lib,
  pkgs,
  ...
}: let
  secretRoot = "morbo";
  envRoot = "env";
  homeDir = config.home.homeDirectory;

  secretNamesJson =
    pkgs.runCommand "morbo-env-secret-names.json" {
      nativeBuildInputs = [pkgs.yq-go];
    } ''
      yq -o=json '(.${secretRoot}.${envRoot} // {} | with_entries(select(.value | tag == "!!str")) | keys)' ${../../../secrets/secrets.yaml} > "$out"
    '';

  secretNames = builtins.fromJSON (builtins.readFile secretNamesJson);

  envVarNameForSecret = secretName:
    lib.toUpper (lib.replaceStrings ["-" "."] ["_" "_"] secretName);

  defaultSecretEnv =
    map (secretName: {
      envVar = envVarNameForSecret secretName;
      file = "/run/secrets/morbo-env-${secretName}";
    })
    secretNames;

  pluginSubmodule = lib.types.submodule (_: {
    options = {
      source = lib.mkOption {
        type = lib.types.oneOf [lib.types.path lib.types.str];
        description = "Local path or flake reference for the plugin root.";
      };

      id = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Optional plugin id override (defaults to openclaw.plugin.json id).";
      };

      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether this plugin entry is enabled in generated config.";
      };

      config = lib.mkOption {
        type = lib.types.attrs;
        default = {};
        description = "Plugin config payload written into plugins.entries.<id>.config.";
      };

      packages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [];
        description = "Additional runtime packages required by this plugin.";
      };

      extraEnv = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = {};
        description = "Non-secret environment variables for this plugin.";
      };
    };
  });

  secretEnvSubmodule = lib.types.submodule (_: {
    options = {
      envVar = lib.mkOption {
        type = lib.types.str;
        description = "Environment variable to export.";
      };

      file = lib.mkOption {
        type = lib.types.str;
        description = "Readable secret file path to load.";
      };
    };
  });
in {
  options.local.openclaw = {
    enable = lib.mkEnableOption "local OpenClaw stack (NixOS-only)";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.openclaw-gateway;
      description = "OpenClaw gateway package to execute.";
    };

    stateDir = lib.mkOption {
      type = lib.types.str;
      default = "${homeDir}/.openclaw";
      description = "State directory for OpenClaw config/runtime files.";
    };

    workspaceDir = lib.mkOption {
      type = lib.types.str;
      default = "${config.local.openclaw.stateDir}/workspace";
      description = "Workspace path exposed to OpenClaw agents.";
    };

    configPath = lib.mkOption {
      type = lib.types.str;
      default = "${config.local.openclaw.stateDir}/openclaw.json";
      description = "Runtime writable OpenClaw config path.";
    };

    baseConfig = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Immutable baseline config merged into runtime config.";
    };

    mutablePaths = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "meta"
        "wizard"
        "auth.profiles"
        "agents"
        "skills.entries"
        "plugins.entries"
        "messages"
        "commands"
      ];
      description = "Allowlisted dotted config paths preserved from runtime config.";
    };

    gatewayPort = lib.mkOption {
      type = lib.types.port;
      default = 18789;
      description = "Gateway service port.";
    };

    logPath = lib.mkOption {
      type = lib.types.str;
      default = "/tmp/openclaw/openclaw-gateway.log";
      description = "Gateway log file path.";
    };

    plugins = lib.mkOption {
      type = lib.types.listOf pluginSubmodule;
      default = [];
      description = "Minimal plugin declarations loaded from path or flake source.";
    };

    secretEnv = lib.mkOption {
      type = lib.types.listOf secretEnvSubmodule;
      default = defaultSecretEnv;
      description = "Secret env var mappings loaded from runtime secret files.";
    };

    seedFromBackup = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Seed first runtime config from openclaw.json.backup when present.";
    };
  };
}
