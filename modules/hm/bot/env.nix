{
  config,
  lib,
  pkgs,
  ...
}: let
  secretRoot = "morbo";
  envRoot = "env";

  secretNamesJson = pkgs.runCommand "morbo-env-secret-names.json" {
    nativeBuildInputs = [pkgs.yq-go];
  } ''
    yq -o=json '(.${secretRoot}.${envRoot} // {} | with_entries(select(.value | tag == "!!str")) | keys)' ${../../../secrets/secrets.yaml} > "$out"
  '';

  secretNames = builtins.fromJSON (builtins.readFile secretNamesJson);

  envVarNameForSecret = secretName:
    lib.toUpper (lib.replaceStrings ["-" "."] ["_" "_"] secretName);

  sopsKeyForSecret = secretName: "${secretRoot}/${envRoot}/${secretName}";

  exportSecrets = lib.concatStringsSep "\n" (map (secretName: let
    envVar = envVarNameForSecret secretName;
  in ''
    if [ -r "${config.sops.secrets.${secretName}.path}" ]; then
      export ${envVar}="$(cat "${config.sops.secrets.${secretName}.path}")"
    fi
  '') secretNames);
in {
  sops.secrets = builtins.listToAttrs (map (secretName: {
      name = secretName;
      value = {
        key = sopsKeyForSecret secretName;
      };
    })
    secretNames);

  programs.bash = {
    profileExtra = lib.mkAfter exportSecrets;
    initExtra = lib.mkAfter exportSecrets;
  };
}
