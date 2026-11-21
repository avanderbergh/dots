{
  flake.modules.nixos."nts-1" = {pkgs, ...}: let
    loadNts1UnitScript = pkgs.writeShellApplication {
      name = "load_nts1_unit";
      runtimeInputs = with pkgs; [
        alsa-utils
        coreutils
        gawk
        gnused
        logue-cli
      ];
      text = ''
        if [ "$#" -ne 1 ]; then
          echo "Usage: $0 <Path to .ntkdigunit file>" >&2
          exit 1
        fi

        tmpdir=$(mktemp -d)
        trap 'rm -rf "$tmpdir"' EXIT

        logue-cli load -v -i 1 -o 1 -u "$1" -d > "$tmpdir/load.log"
        sysex=$(tail -n1 "$tmpdir/load.log" | tr -d ',{}>' | sed 's/^ *//')
        amidi_device=$(amidi -l | awk '/NTS-1/ {print $2; exit}')
        if [ -n "$amidi_device" ]; then
          amidi -p "$amidi_device" -S "$sysex"
        else
          echo "NTS-1 device not found." >&2
          exit 1
        fi
      '';
    };
  in {
    environment.systemPackages = with pkgs; [
      loadNts1UnitScript
      logue-cli
      alsa-utils
    ];
  };
}
