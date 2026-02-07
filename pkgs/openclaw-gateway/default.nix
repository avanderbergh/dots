{
  fetchFromGitHub,
  fetchurl,
  git,
  gawk,
  jq,
  lib,
  makeWrapper,
  node-gyp,
  nodejs_22,
  perl,
  pkg-config,
  pnpm_10,
  python3,
  sourceInfo ? import ./source.nix,
  stdenv,
  vips,
  writeTextFile,
  zstd,
  gatewaySrc ? null,
  pnpmDepsHash ? (sourceInfo.pnpmDepsHash or null),
}:
assert gatewaySrc == null || pnpmDepsHash != null; let
  sourceFetch = lib.removeAttrs sourceInfo ["pnpmDepsHash" "version"];
  pnpmPlatform = "linux";
  pnpmArch =
    if stdenv.hostPlatform.isAarch64
    then "arm64"
    else "x64";

  nodeAddonApi = stdenv.mkDerivation {
    pname = "node-addon-api";
    version = "8.5.0";
    src = fetchurl {
      url = "https://registry.npmjs.org/node-addon-api/-/node-addon-api-8.5.0.tgz";
      hash = "sha256-0S8HyBYig7YhNVGFXx2o2sFiMxN0YpgwteZA8TDweRA=";
    };
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      mkdir -p "$out/lib/node_modules/node-addon-api"
      tar -xf "$src" --strip-components=1 -C "$out/lib/node_modules/node-addon-api"
    '';
  };

  nodeGypWrapper = writeTextFile {
    name = "openclaw-node-gyp-wrapper.sh";
    executable = true;
    text = builtins.readFile ./scripts/node-gyp-wrapper.sh;
  };
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "openclaw-gateway";
    version = sourceInfo.version or sourceInfo.rev;

    src =
      if gatewaySrc != null
      then gatewaySrc
      else fetchFromGitHub sourceFetch;

    pnpmDeps = pnpm_10.fetchDeps {
      inherit (finalAttrs) pname version src;
      hash =
        if pnpmDepsHash != null
        then pnpmDepsHash
        else lib.fakeHash;
      fetcherVersion = 2;
      npm_config_arch = pnpmArch;
      npm_config_platform = pnpmPlatform;
      nativeBuildInputs = [git];
    };

    nativeBuildInputs = [
      nodejs_22
      pnpm_10
      pkg-config
      jq
      python3
      perl
      node-gyp
      makeWrapper
      zstd
      gawk
    ];

    buildInputs = [vips];

    env = {
      SHARP_IGNORE_GLOBAL_LIBVIPS = "1";
      npm_config_arch = pnpmArch;
      npm_config_platform = pnpmPlatform;
      PNPM_CONFIG_MANAGE_PACKAGE_MANAGER_VERSIONS = "false";
      npm_config_nodedir = nodejs_22;
      npm_config_python = python3;
      NODE_PATH = "${nodeAddonApi}/lib/node_modules:${node-gyp}/lib/node_modules";
      NODE_BIN = "${nodejs_22}/bin/node";
      NODE_GYP_WRAPPER_SH = nodeGypWrapper;
    };

    postPatch = builtins.readFile ./scripts/post-patch.sh;
    buildPhase = builtins.readFile ./scripts/build-phase.sh;
    installPhase = builtins.readFile ./scripts/install-phase.sh;

    dontStrip = true;
    dontPatchShebangs = true;

    meta = {
      description = "OpenClaw gateway package for NixOS";
      homepage = "https://github.com/openclaw/openclaw";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux;
      mainProgram = "openclaw";
    };
  })
