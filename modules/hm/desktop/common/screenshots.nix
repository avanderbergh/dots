{
  flake.modules.homeManager."profile-desktop-screenshots" = {pkgs, ...}: let
    screenshotRegion = pkgs.writeShellScriptBin "screenshot-region" ''
      set -euo pipefail
      region=$(${pkgs.slurp}/bin/slurp)
      ${pkgs.grim}/bin/grim -g "$region" - | ${pkgs.satty}/bin/satty --filename -
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
  };
}
