{
  pkgs,
  pkgs-stable,
  config,
  ...
}: {
  # Enable OBS Studio and required plugins
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs-stable; [
      obs-studio-plugins.droidcam-obs
      obs-studio-plugins.obs-websocket
      obs-studio-plugins.obs-shaderfilter
    ];
  };

  # Install obs-cli and xprop (to get window names)
  home.packages = with pkgs; [
    asciicam
    bspwm
    obs-cli
    xorg.xprop
  ];

  # Define the script in your configuration
  home.file.".local/bin/obs-window-switcher.sh".text = ''
    #!/usr/bin/env bash

    # Fetch OBS WebSocket password from sops secret
    OBS_PASSWORD=$(cat ${config.sops.secrets.obs_password.path})

    # Function to switch scenes in OBS
    switch_scene() {
      local scene_name=$1
      obs-cli --password "$OBS_PASSWORD" scene switch "$scene_name"
    }

    # Subscribe to bspwm focus change events
    bspc subscribe node_focus | while read -r _ _ _ window_id; do
      # Get the name of the focused window
      window_name=$(xprop -id "$window_id" WM_NAME | cut -d '"' -f 2)

      if [[ "$window_name" == *"Google Chrome"* ]]; then
        switch_scene "Browser"
      elif [[ "$window_name" == *"Visual Studio Code"* ]]; then
        switch_scene "Code Editor"
      fi
    done
  '';

  # Ensure the script is executable using the 'mode' option
  home.file.".local/bin/obs-window-switcher.sh".executable = true;

  # Define the secret for OBS WebSocket password (Scoped for Home Manager)
  sops.secrets.obs_password = {};

  # Add systemd service to run the script in the background
  systemd.user.services.obs-window-switcher = {
    Unit = {
      Description = "Service Description";
      After = ["graphical-session.target" "sops-nix.service"]; # This can be omitted if not necessary
    };

    Service = {
      Environment = ["DISPLAY=:0" "XAUTHORITY=${config.home.homeDirectory}/.Xauthority"];
      ExecStart = "${config.home.homeDirectory}/.local/bin/obs-window-switcher.sh";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = ["default.target"];
    };
  };
}
