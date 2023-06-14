{
  lib,
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation rec {
  pname = "shantell-sans";
  version = "1.008";

  src = fetchzip {
    url = "https://github.com/arrowtype/shantell-sans/releases/download/${version}/Shantell_Sans_${version}.zip";
    hash = "sha256-jll9fTNVdnPM0uSFYpW7EfUzsQo+6SAdNtL482EGLxo=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/fonts/truetype"

    cd Desktop

    mv Static $out/share/fonts/opentype
    mv *.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "Shantell Sans, from Shantell Martin, is a marker-style font built for creative expression, typographic play, and animation.";
    homepage = "https://github.com/arrowtype/shantell-sans";
    license = licenses.ofl;
    maintainers = with maintainers; [avanderbergh];
    platforms = platforms.all;
  };
}
