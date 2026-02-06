{
  pkgs,
  ...
}: let
  secretRoot = "morbo";
  envRoot = "env";

  envSecretNamesJson = pkgs.runCommand "morbo-env-secret-names.json" {
    nativeBuildInputs = [pkgs.yq-go];
  } ''
    yq -o=json '(.${secretRoot}.${envRoot} // {} | with_entries(select(.value | tag == "!!str")) | keys)' ${../../secrets/secrets.yaml} > "$out"
  '';

  envSecretNames = builtins.fromJSON (builtins.readFile envSecretNamesJson);

  morboEnvSecrets = builtins.listToAttrs (map (secretName: {
      name = "morbo-env-${secretName}";
      value = {
        key = "${secretRoot}/${envRoot}/${secretName}";
        owner = "morbo";
        group = "morbo";
        mode = "0400";
      };
    })
    envSecretNames);
in {
  sops.secrets =
    morboEnvSecrets
    // {
      morbo-ssh = {
        key = "${secretRoot}/ssh";
        owner = "morbo";
        group = "morbo";
        mode = "0400";
      };
    };
}
