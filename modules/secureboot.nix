{ lib, ... }:
{
  boot.bootspec.enable = true;
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  security.tpm2.enable = true;
  security.tpm2.tctiEnvironment.enable = true;
}