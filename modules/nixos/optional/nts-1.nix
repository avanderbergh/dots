{pkgs, ...}: let
  loadNts1UnitScript = pkgs.writeShellScriptBin "load_nts1_unit" ''
    #!${pkgs.stdenv.shell}
    if [ "$#" -ne 1 ]; then
      echo "Usage: $0 <Path to .ntkdigunit file>"
      exit 1
    fi

    logue-cli load -v -i 1 -o 1 -u $1 -d > load.log
    tail -n1 load.log | sed 's/,//g' | sed 's/}//g' | sed 's/{//g' | sed 's/>//g' | sed 's/^ *//g' > load.sysex
    AMIDI_DEVICE=$(amidi -l | grep 'NTS-1' | awk '{print $2}')
    if [ -n "$AMIDI_DEVICE" ]; then
      amidi -p $AMIDI_DEVICE -S $(cat load.sysex)
    else
      echo "NTS-1 device not found."
    fi

    # Clean up
    rm -f load.log load.sysex
  '';
in {
  environment.systemPackages = with pkgs; [
    loadNts1UnitScript
    logue-cli
    alsa-utils
  ];
}
