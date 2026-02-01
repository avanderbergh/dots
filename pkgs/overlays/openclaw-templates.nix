final: prev: let
  patchedGateway = prev.openclaw-gateway.overrideAttrs (oldAttrs: {
    installPhase = ''
      ${oldAttrs.installPhase}
      mkdir -p $out/lib/openclaw/docs/reference/templates
      cp -r $src/docs/reference/templates/* $out/lib/openclaw/docs/reference/templates/
    '';
  });

  patchOpenclawBundle = pkg: oldGateway:
    pkg.overrideAttrs (oldAttrs: {
      paths =
        [patchedGateway]
        ++ builtins.filter (p: p != oldGateway && p != patchedGateway) (oldAttrs.paths or []);
    });

  patchedOpenclaw = patchOpenclawBundle prev.openclaw prev.openclaw-gateway;

  patchedOpenclawPackages =
    prev.openclawPackages
    // {
      openclaw-gateway = patchedGateway;
      openclaw = patchedOpenclaw;
      withTools = {
        toolNamesOverride ? null,
        excludeToolNames ? [],
      }: let
        packages = prev.openclawPackages.withTools {
          inherit toolNamesOverride excludeToolNames;
        };
      in
        packages
        // {
          openclaw-gateway = patchedGateway;
          openclaw = patchOpenclawBundle packages.openclaw packages.openclaw-gateway;
        };
    };
in {
  openclaw-gateway = patchedGateway;
  openclaw = patchedOpenclaw;
  openclawPackages = patchedOpenclawPackages;
}
