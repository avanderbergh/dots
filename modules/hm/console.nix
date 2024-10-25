{
  colors,
  pkgs,
  ...
}: {
  programs = {
    alacritty = {
      enable = true;
      settings = {
        env.TERM = "xterm-256color";
        window = {
          padding = {
            x = 10;
            y = 10;
          };
          opacity = 0.5;
        };
        font = {
          normal = {
            family = "VictorMono Nerd Font";
            style = "Regular";
          };
          bold = {
            family = "VictorMono Nerd Font";
            style = "Bold";
          };
          italic = {
            family = "VictorMono Nerd Font";
            style = "Italic";
          };
          bold_italic = {
            family = "VictorMono Nerd Font";
            style = "Bold Italic";
          };
        };
      };
    };

    eza = {
      enable = true;
      enableFishIntegration = true;
      git = true;
      icons = "auto";
    };

    fish = {
      enable = true;
      functions = {
        __fish_command_not_found_handler = {
          body = "__fish_default_command_not_found_handler $argv[1]";
          onEvent = "fish_command_not_found";
        };

        fish_greeting = "";

        gitignore = "curl -sL https://www.gitignore.io/api/$argv";
      };
      shellAliases = {
        g = "git";
        get = "ghq get -p -u";
        create = "ghq create";
      };
    };
    fzf.enable = true;
    lf.enable = true;
    starship.enable = true;
    # tealdeer.enable = true;
    btop = {
      enable = true;
      settings = {
        theme_background = false;
      };
    };
  };
}
