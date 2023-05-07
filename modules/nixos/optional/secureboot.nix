{
  inputs,
  lib,
  ...
}: {
  imports = [inputs.lanzaboote.nixosModules.lanzaboote];

  boot.bootspec.enable = true;
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  # To enable TPM2 support, you need to enroll the TPM2 device first:
  # sudo systemd-cryptenroll --tpm2-device=list
  # sudo systemd-cryptenroll --wipe-slot=tpm2 /dev/disk/by-label/luks --tpm2-device=auto --tpm2-pcrs=0+2+7

  security.tpm2.enable = true;
  security.tpm2.tctiEnvironment.enable = true;

  environment.persistence."/persist".directories = ["/etc/secureboot"];
}
