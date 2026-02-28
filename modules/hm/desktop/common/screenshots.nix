{pkgs, ...}: let
  screenshotRegion = pkgs.writeShellScriptBin "screenshot-region" ''
    set -euo pipefail
    ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.satty}/bin/satty --filename -
  '';

  screenshotScreen = pkgs.writeShellScriptBin "screenshot-screen" ''
    set -euo pipefail
    ${pkgs.grim}/bin/grim - | ${pkgs.satty}/bin/satty --filename -
  '';
in {
  home.packages = with pkgs; [
    grim
    satty
    slurp
    screenshotRegion
    screenshotScreen
  ];
}
