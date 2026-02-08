{
  lib,
  buildNpmPackage,
  fetchzip,
}:
buildNpmPackage (finalAttrs: {
  pname = "pi-coding-agent";
  version = "0.52.8";

  src = fetchzip {
    url = "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-${finalAttrs.version}.tgz";
    hash = "sha256-O2O/a28S4Qogue1iGSOthZi0VmofTzAq3R5k0SaPSN0=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-yS+6/SSp8yGqncOskpe1PMxSorLgX6A6cn2GjVjGPNw=";
  dontNpmBuild = true;

  meta = with lib; {
    description = "pi.dev coding agent CLI";
    homepage = "https://pi.dev";
    license = licenses.mit;
    mainProgram = "pi";
    platforms = platforms.unix;
  };
})
