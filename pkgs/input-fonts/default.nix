{
  stdenvNoCC,
  pkgs,
}:
stdenvNoCC.mkDerivation {
  pname = "input-fonts";
  version = "1.0";
  nativeBuildInputs = [pkgs.unzip];
  buildInputs = [pkgs.unzip];

  src = ./src/Input-Font.zip;
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/fonts/truetype"

    mv ./Input_Fonts "$out/share/fonts/truetype"

    runHook postInstal
  '';
}
