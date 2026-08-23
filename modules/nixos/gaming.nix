{
  flake.modules.nixos.gaming = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.local.gaming;
    gameEnvironment =
      lib.optionalAttrs (cfg.preferredVulkanDevice != null) {
        MESA_VK_DEVICE_SELECT = "${cfg.preferredVulkanDevice}!";
      }
      // lib.optionalAttrs cfg.nvidiaPrimeOffload {
        __NV_PRIME_RENDER_OFFLOAD = "1";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        __VK_LAYER_NV_optimus = "NVIDIA_only";
      };

    # Niri recommends nested Gamescope for fullscreen games that need reliable
    # cursor confinement. Use this as a Steam launch option: niri-game %command%
    niri-game = pkgs.writeShellScriptBin "niri-game" ''
      if [ "$#" -eq 0 ]; then
        echo "usage: niri-game <game> [arguments...]" >&2
        exit 64
      fi

      ${lib.optionalString (cfg.preferredVulkanDevice != null) ''
        # Ensure the game uses the same GPU as the Gamescope compositor.
        export MESA_VK_DEVICE_SELECT=${lib.escapeShellArg "${cfg.preferredVulkanDevice}!"}
      ''}
      ${lib.optionalString cfg.nvidiaPrimeOffload ''
        export __NV_PRIME_RENDER_OFFLOAD=1
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
        export __VK_LAYER_NV_optimus=NVIDIA_only
      ''}

      exec /run/wrappers/bin/gamescope \
        --fullscreen \
        --force-grab-cursor \
        -- \
        ${pkgs.gamemode}/bin/gamemoderun "$@"
    '';
  in {
    options.local.gaming.preferredVulkanDevice = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "10de:1f12";
      description = ''
        PCI vendor and device ID that Gamescope should prefer for compositing.
      '';
    };

    options.local.gaming.nvidiaPrimeOffload = lib.mkEnableOption ''
      NVIDIA PRIME render offload for Steam and games launched with niri-game
    '';

    config = {
      programs = {
        steam = {
          enable = true;
          extest.enable = true;
          protontricks.enable = true;
          extraCompatPackages = [pkgs.proton-ge-bin];
          package = pkgs.steam.override {
            extraEnv = gameEnvironment;
          };
        };

        gamemode = {
          enable = true;
          settings.general.renice = 10;
        };

        gamescope = {
          enable = true;
          capSysNice = true;
          # The SDL backend currently provides reliable cursor locking under Niri.
          args =
            ["--backend" "sdl"]
            ++ lib.optionals (cfg.preferredVulkanDevice != null) [
              "--prefer-vk-device"
              cfg.preferredVulkanDevice
            ];
        };
      };

      environment.systemPackages = [
        pkgs.mangohud
        niri-game
      ];

      # GameMode's polkit policy grants governor changes to this group.
      users.users.${config.local.users.ownerName}.extraGroups = ["gamemode"];
    };
  };
}
