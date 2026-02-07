{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local.openclaw;
  inherit (config.home) homeDirectory username;
  homeDir = homeDirectory;

  mkdirExe = lib.getExe' pkgs.coreutils "mkdir";
  installExe = lib.getExe' pkgs.coreutils "install";
  lnExe = lib.getExe' pkgs.coreutils "ln";
  nodeExe = lib.getExe pkgs.nodejs;

  reconcileScriptPath = toString ../../../scripts/openclaw/reconcile-config.mjs;
  gatewayWrapperText = builtins.readFile ../../../scripts/openclaw/gateway-wrapper.sh;
  gatewayWrapperBin = pkgs.writeShellScriptBin "openclaw-gateway-wrapper" gatewayWrapperText;
  gatewayWrapperExe = "${gatewayWrapperBin}/bin/openclaw-gateway-wrapper";

  baseConfigPath = "${cfg.stateDir}/openclaw.base.json";
  backupConfigPath = "${cfg.configPath}.backup";
  pluginsDir = "${cfg.stateDir}/plugins";

  sanitizePathSegment = value:
    lib.replaceStrings [" " "/" ":" "@" "\t"] ["-" "-" "-" "-" "-"] value;

  resolvePluginRoot = source:
    if builtins.isPath source
    then toString source
    else let
      src = toString source;
    in
      if lib.hasPrefix "~/" src
      then "${homeDir}/${lib.removePrefix "~/" src}"
      else if lib.hasPrefix "/" src
      then src
      else (builtins.getFlake src).outPath;

  resolvePlugin = plugin: let
    root = resolvePluginRoot plugin.source;
    manifestPath = "${root}/openclaw.plugin.json";
    hasManifest = builtins.pathExists manifestPath;
    manifestEval =
      if hasManifest
      then builtins.tryEval (builtins.fromJSON (builtins.readFile manifestPath))
      else {
        success = false;
        value = null;
      };
    manifest =
      if manifestEval.success && builtins.isAttrs manifestEval.value
      then manifestEval.value
      else {};
    manifestId =
      if manifest ? id && builtins.isString manifest.id && manifest.id != ""
      then manifest.id
      else null;
    pluginId =
      if plugin.id != null
      then plugin.id
      else manifestId;
  in
    plugin
    // {
      inherit root hasManifest manifestPath manifestId pluginId;
      linkName =
        if pluginId != null && pluginId != ""
        then sanitizePathSegment pluginId
        else sanitizePathSegment (builtins.baseNameOf root);
    };

  resolvedPlugins = map resolvePlugin cfg.plugins;

  pluginIdCounts = lib.foldl' (acc: plugin:
    if plugin.pluginId == null || plugin.pluginId == ""
    then acc
    else acc // {"${plugin.pluginId}" = (acc.${plugin.pluginId} or 0) + 1;}) {}
  resolvedPlugins;

  duplicatePluginIds = lib.attrNames (lib.filterAttrs (_: count: count > 1) pluginIdCounts);

  pluginLoadPaths = map (plugin: "${pluginsDir}/${plugin.linkName}") resolvedPlugins;

  pluginEntries = lib.listToAttrs (map (plugin: {
      name = plugin.pluginId;
      value =
        {
          enabled = plugin.enable;
        }
        // lib.optionalAttrs (plugin.config != {}) {
          inherit (plugin) config;
        };
    })
    (lib.filter (plugin: plugin.pluginId != null && plugin.pluginId != "") resolvedPlugins));

  pluginPackages = lib.flatten (map (plugin: plugin.packages) resolvedPlugins);
  pluginExtraEnv = lib.foldl' lib.recursiveUpdate {} (map (plugin: plugin.extraEnv) resolvedPlugins);

  basePluginPaths = lib.attrByPath ["plugins" "load" "paths"] [] cfg.baseConfig;
  generatedBaseConfig = lib.recursiveUpdate cfg.baseConfig {
    gateway.port = cfg.gatewayPort;
    plugins = {
      load.paths = lib.unique (basePluginPaths ++ pluginLoadPaths);
      entries = pluginEntries;
    };
  };

  baseConfigStoreFile = pkgs.writeText "openclaw.base.json" (builtins.toJSON generatedBaseConfig);

  mutablePathArgs = lib.flatten (map (path: ["--mutable-path" path]) cfg.mutablePaths);
  reconcileArgs =
    [
      reconcileScriptPath
      "--base"
      baseConfigPath
      "--runtime"
      cfg.configPath
      "--backup"
      backupConfigPath
    ]
    ++ lib.optionals cfg.seedFromBackup ["--seed-from-backup"]
    ++ mutablePathArgs;

  wrapperArgs =
    [
      gatewayWrapperExe
      "--openclaw-bin"
      "${cfg.package}/bin/openclaw"
      "--port"
      (toString cfg.gatewayPort)
    ]
    ++ (lib.flatten (map (entry: [
        "--secret-env"
        "${entry.envVar}=${entry.file}"
      ])
      cfg.secretEnv));

  activationDirs = lib.unique [
    cfg.stateDir
    cfg.workspaceDir
    pluginsDir
    (builtins.dirOf cfg.logPath)
    (builtins.dirOf cfg.configPath)
  ];

  pluginSymlinkCommands = lib.concatStringsSep "\n" (map (plugin: ''
      run --quiet ${lnExe} -sfn ${lib.escapeShellArg plugin.root} ${lib.escapeShellArg "${pluginsDir}/${plugin.linkName}"}
    '')
    resolvedPlugins);

  systemPath = "/etc/profiles/per-user/${username}/bin:/run/current-system/sw/bin:/bin";
in {
  config = lib.mkIf cfg.enable {
    assertions =
      [
        {
          assertion = pkgs.stdenv.hostPlatform.isLinux;
          message = "local.openclaw is Linux-only.";
        }
        {
          assertion = duplicatePluginIds == [];
          message = "local.openclaw.plugins has duplicate plugin ids: ${lib.concatStringsSep ", " duplicatePluginIds}";
        }
      ]
      ++ map (plugin: {
        assertion = plugin.hasManifest;
        message = "local.openclaw.plugins source ${plugin.root} is missing openclaw.plugin.json.";
      })
      resolvedPlugins
      ++ map (plugin: {
        assertion = plugin.pluginId != null && plugin.pluginId != "";
        message = "local.openclaw.plugins source ${plugin.root} must define an id (option id or manifest id).";
      })
      resolvedPlugins;

    home.packages = lib.unique ([cfg.package] ++ pluginPackages);

    home.activation.openclawLocalStack = lib.hm.dag.entryAfter ["writeBoundary"] ''
      run --quiet ${mkdirExe} -p ${lib.concatStringsSep " " (map lib.escapeShellArg activationDirs)}
      run --quiet ${installExe} -D -m 600 ${lib.escapeShellArg baseConfigStoreFile} ${lib.escapeShellArg baseConfigPath}
      ${pluginSymlinkCommands}
      run --quiet ${nodeExe} ${lib.concatStringsSep " " (map lib.escapeShellArg reconcileArgs)}
    '';

    systemd.user.services.openclaw-gateway = {
      Unit = {
        Description = "OpenClaw gateway";
      };
      Service = {
        ExecStart = lib.concatStringsSep " " (map lib.escapeShellArg wrapperArgs);
        WorkingDirectory = cfg.stateDir;
        Restart = "always";
        RestartSec = "1s";
        Environment =
          [
            "HOME=${homeDir}"
            "OPENCLAW_CONFIG_PATH=${cfg.configPath}"
            "OPENCLAW_STATE_DIR=${cfg.stateDir}"
            "OPENCLAW_NIX_MODE=1"
            "PATH=${systemPath}"
          ]
          ++ lib.mapAttrsToList (name: value: "${name}=${value}") pluginExtraEnv;
        StandardOutput = "append:${cfg.logPath}";
        StandardError = "append:${cfg.logPath}";
      };
      Install = {
        WantedBy = ["default.target"];
      };
    };
  };
}
