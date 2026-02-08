{
  lib,
  buildNpmPackage,
  fetchurl,
}:
buildNpmPackage rec {
  pname = "pi-coding-agent";
  version = "0.52.8";

  src = fetchurl {
    url = "https://registry.npmjs.org/@mariozechner/pi-coding-agent/-/pi-coding-agent-${version}.tgz";
    hash = "sha256-zw4R20/TQztVIMKc52PHTcyXLRTdYAuuaDOn1WC9q3Y=";
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
}
