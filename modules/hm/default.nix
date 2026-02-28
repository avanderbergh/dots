{
  pkgs,
  pkgs-stable,
  ...
}: {
  home = {
    username = "avanderbergh";
    homeDirectory = "/home/avanderbergh";
    stateVersion = "23.11";

    packages = [
      # pkgs-stable.cura
      # pkgs-stable.figma-agent
      pkgs-stable.cava
      pkgs.alejandra
      pkgs.cloudflared
      pkgs.esptool
      pkgs.git
      pkgs.joshuto
      pkgs.libgen-cli
      pkgs.ncdu
      pkgs.nixd
      pkgs.nvtopPackages.full
      pkgs.pgcli
      pkgs.ripgrep
      pkgs.statix
      pkgs.unzip
    ];
  };

  programs = {
    home-manager.enable = true;
    pandoc.enable = true;
  };
}
