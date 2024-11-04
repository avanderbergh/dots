{pkgs, ...}: {
  home = {
    username = "avanderbergh";
    homeDirectory = "/home/avanderbergh";
    stateVersion = "23.11";

    packages = with pkgs; [
      alejandra
      # bitwig-studio
      # https://github.com/NixOS/nixpkgs/issues/352873
      # blender
      brightnessctl
      # Failing to build
      # calibre
      cava
      # error: sip-4.19.25 not supported for interpreter python3.12
      # cura
      davinci-resolve
      discord-canary
      esptool
      expressvpn
      # Failed to build
      # figma-agent
      firefox
      google-chrome
      joshuto
      ledger-live-desktop
      libgen-cli
      libresprite
      logseq
      ncdu
      nsxiv
      obsidian
      openscad
      orca-slicer
      pcmanfm
      pgcli
      pinokio
      signal-desktop
      slack
      telegram-desktop
      unzip
      wpsoffice
      xarchiver
      xclip
      xdotool
      xorg.xev
      xsel
    ];
  };

  programs = {
    home-manager.enable = true;
    mpv.enable = true;
    pandoc.enable = true;
    vscode = {
      enable = true;
      package = pkgs.vscode.fhs;
      # package = (pkgs.vscode.override {isInsiders = true;}).overrideAttrs (oldAttrs: rec {
      #   src = builtins.fetchTarball {
      #     url = "https://update.code.visualstudio.com/latest/linux-x64/insider";
      #     sha256 = "1cgrn4n6y348x0c7ndmn5vssvpj1sdk27bp91cayr27fb59lgmv9";
      #   };
      #   version = "latest";
      # });
    };
    zathura.enable = true;
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowCuda = true;
      allowUnfreePredicate = _: true;
    };
  };

  services.udiskie.enable = true;
}
