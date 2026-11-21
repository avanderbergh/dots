{
  stdenvNoCC,
  unzip,
}:
stdenvNoCC.mkDerivation {
  pname = "input-fonts";
  version = "1.0";
  nativeBuildInputs = [unzip];

  src = ./src/Input-Font.zip;
  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/fonts/truetype"

    mv ./Input_Fonts "$out/share/fonts/truetype"

    runHook postInstall
  '';
}
