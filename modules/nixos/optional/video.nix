{pkgs, ...}: {
  boot.kernelModules = ["firewire-ohci"];
  environment.systemPackages = with pkgs; [
    dvgrab
    exiftool
    ffmpeg
  ];
}
