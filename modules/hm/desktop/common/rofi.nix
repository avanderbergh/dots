{
  config,
  colors,
  ...
}: let
  inherit (config.lib.formats.rasi) mkLiteral;
in {
  programs.rofi = {
    enable = true;
    font = "Victor Mono 32";
    extraConfig = {
      modi = "run,drun,window";
      icon-theme = "Oranchelo";
      show-icons = true;
      terminal = "alacritty";
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      display-drun = "   Apps ";
      display-run = "   Run ";
      display-window = " 﩯  Window";
      display-Network = " 󰤨  Network";
      sidebar-mode = true;
    };
    theme = {
      "element-text, element-icon, mode-switcher" = {
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };
      "window" = {
        height = mkLiteral "720px";
        background-color = mkLiteral "${colors.base}";
        border = mkLiteral "6px";
        border-radius = mkLiteral "40px";
        border-color = mkLiteral "${colors.surface0}";
      };
      "mainbox" = {
        background-color = mkLiteral "${colors.base}";
      };
      "inputbar" = {
        children = mkLiteral " [prompt,entry]";
        background-color = mkLiteral "${colors.base}";
        border-radius = mkLiteral "10px";
        padding = mkLiteral "4px";
      };
      "prompt" = {
        background-color = mkLiteral "${colors.blue}";
        padding = mkLiteral "12px";
        text-color = mkLiteral "${colors.base}";
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
        text-color = mkLiteral "${colors.text}";
        background-color = mkLiteral "${colors.base}";
      };
      "listview" = {
        border = mkLiteral "0px 0px 0px";
        padding = mkLiteral "12px 0px 0px";
        margin = mkLiteral "20px 0px 0px 40px";
        columns = 2;
        lines = 5;
        background-color = mkLiteral "${colors.base}";
      };
      "element" = {
        padding = mkLiteral "10px";
        background-color = mkLiteral "${colors.base}";
        text-color = mkLiteral "${colors.text}";
      };
      "element-icon" = {
        size = mkLiteral "50px";
      };
      "element selected" = {
        background-color = mkLiteral "${colors.mauve}";
        border-radius = mkLiteral "20px";
        text-color = mkLiteral "${colors.base}";
      };
      "mode-switcher" = {
        spacing = 0;
      };
      "button" = {
        padding = mkLiteral "20px";
        background-color = mkLiteral "${colors.surface0}";
        text-color = mkLiteral "${colors.overlay0}";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.5";
      };

      "button selected" = {
        background-color = mkLiteral "${colors.base}";
        text-color = mkLiteral "${colors.blue}";
      };

      "message" = {
        background-color = mkLiteral "${colors.surface0}";
        margin = mkLiteral "4px";
        padding = mkLiteral "4px";
        border-radius = mkLiteral "10px";
      };
      "textbox" = {
        padding = mkLiteral "12px";
        margin = mkLiteral "40px 0px 0px 40px";
        text-color = mkLiteral "${colors.blue}";
        background-color = "${colors.base}";
      };
    };
  };
}
