{ pkgs, ... }:

let
  dbus-hyprland-environment = pkgs.writeTextFile {
    name = "dbus-hyprland-environment";
    destination = "/bin/dbus-hyprland-environment";
    executable = true;
    text = ''
      dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=hyprland
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire wireplumber pipewire-media-session xdg-desktop-portal xdg-desktop-portal-hyprland
    '';
  };
in {

  environment = {

    etc."greetd/environments".text = ''
      Hyprland
    '';

    sessionVariables = {
      __GL_GSYNC_ALLOWED = "0";
      __GL_VRR_ALLOWED = "0";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      GBM_BACKEND = "nvidia-drm";
      GDK_BACKEND = "wayland";
      LIBVA_DRIVER_NAME = "nvidia";
      MOZ_ENABLE_WAYLAND = "1";
      NIXOS_OZONE_WL = "1";
      PATH = [ "$HOME/.local/bin/:$PATH" ];
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      # VK_INSTANCE_LAYERS = "VK_LAYER_KHRONOS_validation";
      WLR_BACKEND = "vulkan";
      # WLR_DRM_NO_ATOMIC = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
      WLR_RENDERER = "vulkan";
      XCURSOR_SIZE = "24";
      XDG_SESSION_TYPE = "wayland";
    };

    systemPackages = with pkgs; [
      dbus-hyprland-environment
      glib
      grim
      slurp
      swayidle
      swaylock-effects
      swww
      vulkan-validation-layers
      wayland
      wl-clipboard
      wlogout
      wlr-randr
      wofi
    ];
  };

  programs.xwayland.enable = true;

  services = {
    dbus.enable = true;
    greetd = {
      enable = false;
      settings = rec {
        initial_session = {
          command = "Hyprland";
          user = "avanderbergh";
        };
        default_session = initial_session;
      };
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

}
