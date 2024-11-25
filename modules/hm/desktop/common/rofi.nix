{
  config,
  colors,
  pkgs,
  lib,
  ...
}: let
  inherit (config.lib.formats.rasi) mkLiteral;
in {
  programs.rofi = {
    enable = true;
    extraConfig = {
      modi = "run,drun,window";
      icon-theme = "Oranchelo";
      show-icons = true;
      terminal = "alacritty";
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "Apps";
      display-run = "Run";
      display-window = "Window";
      display-Network = "Network";
      sidebar-mode = true;
    };
    plugins = with pkgs; [
      rofi-calc
      rofi-emoji
      rofi-power-menu
    ];
    theme = {
      "element-text, element-icon, mode-switcher" = {
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };
      "window" = {
        height = mkLiteral "720px";
        border = mkLiteral "6px";
        border-radius = mkLiteral "40px";
      };
      "inputbar" = {
        children = mkLiteral " [prompt,entry]";
        border-radius = mkLiteral "10px";
        padding = mkLiteral "4px";
      };
      "prompt" = {
        padding = mkLiteral "12px";
        border-radius = mkLiteral "20px";
        margin = mkLiteral "40px 0px 0px 40px";
      };
      "textbox-prompt-colon" = {
        expand = "false";
        str = ":";
      };
      "entry" = {
        padding = mkLiteral "12px";
        margin = mkLiteral "40px 0px 0px 20px";
      };
      "listview" = {
        border = mkLiteral "0px 0px 0px";
        padding = mkLiteral "12px 0px 0px";
        margin = mkLiteral "20px 0px 0px 40px";
        columns = 2;
        lines = 5;
      };
      "element" = {
        padding = mkLiteral "10px";
      };
      "element-icon" = {
        size = mkLiteral "50px";
      };
      "element selected" = {
        border-radius = mkLiteral "20px";
      };
      "mode-switcher" = {
        spacing = 0;
      };
      "button" = {
        padding = mkLiteral "20px";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.5";
      };

      "message" = {
        margin = mkLiteral "4px";
        padding = mkLiteral "4px";
        border-radius = mkLiteral "10px";
      };
      "textbox" = {
        padding = mkLiteral "12px";
        margin = mkLiteral "40px 0px 0px 40px";
      };
    };
  };
}
