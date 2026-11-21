{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  alsa-lib,
  gcc,
}:
stdenv.mkDerivation rec {
  pname = "logue-cli";
  version = "0.07-2b";

  src = fetchurl {
    url = "http://cdn.storage.korg.com/korg_SDK/logue-cli-linux64-${version}.tar.gz";
    hash = "sha256-bCwWVrkSf9jmd8UKqm7xX/u6A2A/tZXbb+6URnQqxU8=";
  };

  nativeBuildInputs = [autoPatchelfHook];
  buildInputs = [alsa-lib gcc.cc stdenv.cc.cc.lib];

  dontBuild = true;

  unpackPhase = "tar -xzf $src";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp logue-cli-linux64-${version}/logue-cli $out/bin/
    chmod +x $out/bin/logue-cli

    runHook postInstall
  '';

  meta = with lib; {
    description = "CLI tool for managing Korg logue-series synthesizers";
    homepage = "https://www.korg.com";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
