_: {
  services.swaync = {
    enable = true;
    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      layer-shell = true;
      cssPriority = "application";
      fit-to-screen = true;
      timeout = 10;
      timeout-low = 5;
      timeout-critical = 0;
      "control-center-layer" = "top";
      "control-center-positionX" = "right";
      "control-center-positionY" = "top";
      "control-center-margin-top" = 8;
      "control-center-margin-right" = 8;
      "notification-window-width" = 420;
      "notification-icon-size" = 48;
      widgets = [
        "dnd"
        "title"
        "notifications"
        "mpris"
      ];
    };

    style = ''
      .control-center,
      .notification-row .notification-background .notification {
        border-radius: 16px;
      }

      .notification-row:focus,
      .notification-row:hover {
        border-radius: 16px;
      }
    '';
  };
}
