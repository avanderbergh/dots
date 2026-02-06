{
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

  secretFileForSecret = secretName: "/run/secrets/morbo-env-${secretName}";

  exportSecrets = lib.concatStringsSep "\n" (map (secretName: let
    envVar = envVarNameForSecret secretName;
    secretFile = secretFileForSecret secretName;
  in ''
    if [ -r "${secretFile}" ]; then
      export ${envVar}="$(cat "${secretFile}")"
    fi
  '') secretNames);
in {
  programs.bash = {
    profileExtra = lib.mkAfter exportSecrets;
    initExtra = lib.mkAfter exportSecrets;
  };
}
