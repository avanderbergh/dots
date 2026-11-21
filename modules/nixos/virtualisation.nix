{
  flake.modules.nixos.virtualisation = {
    config,
    pkgs,
    ...
  }: {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = false;
        swtpm.enable = true;
      };
    };

    programs.virt-manager.enable = true;

    users.users.${config.local.users.ownerName}.extraGroups = ["kvm" "libvirtd"];

    environment.systemPackages = with pkgs; [
      cdrkit
      cloud-utils
      qemu_kvm
      quickemu
      virtiofsd
    ];

    environment.persistence."/persist" = {
      directories = [
        "/var/lib/libvirt"
      ];
    };
  };
}
