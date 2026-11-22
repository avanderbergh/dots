{
  flake.modules.homeManager."profile-sops" = {pkgs, ...}: {
    home = {
      # Dynamically load the PIV identity of whichever YubiKey is plugged in
      # instead of reading root-owned /etc/ssh/ssh_host_ed25519_key.
      sessionVariables.SOPS_AGE_KEY_CMD = "${pkgs.age-plugin-yubikey}/bin/age-plugin-yubikey --identity";
      packages = with pkgs; [
        age
        age-plugin-yubikey
        sops
        ssh-to-age
      ];
    };
  };
}
