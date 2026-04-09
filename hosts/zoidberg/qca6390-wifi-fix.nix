# The QCA6390 WiFi firmware crashes on every resume.
# swayidle auto-suspends after 20min idle, so this happens frequently.
# On resume, ath11k fails to reinitialize the firmware (regulatory info -22),
# runs degraded, then the firmware hard-crashes 5-15 min later.
# Reloading the driver after suspend forces a clean firmware init.
# See ~/wifi-debug-note.md for full diagnosis.
{pkgs, ...}: let
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
}
