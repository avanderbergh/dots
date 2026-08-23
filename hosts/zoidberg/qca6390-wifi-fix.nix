{
  flake.modules.nixos."host-zoidberg-qca6390-wifi-fix" = {pkgs, ...}: let
    modprobe = "${pkgs.lib.getExe' pkgs.kmod "modprobe"}";
  in {
    # The QCA6390 firmware can crash across suspend. Run from NixOS's native
    # post-resume hook so the reload happens after every sleep cycle.
    powerManagement.resumeCommands = ''
      ${pkgs.coreutils}/bin/sleep 3
      ${modprobe} -r ath11k_pci
      ${modprobe} ath11k_pci
    '';
  };
}
