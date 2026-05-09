{
  flake.modules.nixos."host-zoidberg-qca6390-wifi-fix" = {pkgs, ...}: let
    modprobe = "${pkgs.lib.getExe' pkgs.kmod "modprobe"}";
  in {
    systemd.services."ath11k-resume" = {
      description = "Reload ath11k driver after suspend to fix QCA6390 firmware crash";
      after = ["suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target"];
      wantedBy = ["suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target"];
      serviceConfig = {
        Type = "oneshot";
        ExecStartPre = "/bin/sleep 3";
        ExecStart = [
          "${modprobe} -r ath11k_pci"
          "${modprobe} ath11k_pci"
        ];
        RemainAfterExit = "yes";
      };
    };
  };
}
