{pkgs, ...}: {
  home.packages = with pkgs; [
    bottom
    duf
    dust
    gitui
    glow
    just
    tokei
    yazi
  ];

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
        };
      };
    };

    atuin = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        auto_sync = true;
        sync_frequency = "5m";
        update_check = false;
      };
    };

    bat.enable = true;

    btop = {
      enable = true;
      settings = {
        theme_background = false;
      };
    };

    eza = {
      enable = true;
      enableFishIntegration = true;
      git = true;
      icons = "auto";
    };

    fd.enable = true;

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
    lazygit.enable = true;
    lf.enable = true;

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
      withPython3 = true;

      extraPackages = with pkgs; [
        # LSP servers
        bash-language-server
        clang-tools
        dockerfile-language-server
        gopls
        lua-language-server
        marksman
        nixd
        pyright
        rust-analyzer
        taplo
        typescript-language-server
        vscode-langservers-extracted
        yaml-language-server

        # formatters / tooling
        alejandra
        black
        gofumpt
        isort
        prettierd
        shfmt
        stylua
      ];

      plugins = with pkgs.vimPlugins; [
        plenary-nvim
        telescope-nvim
        telescope-fzf-native-nvim
        nvim-lspconfig
        nvim-cmp
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        cmp_luasnip
        luasnip
        nvim-treesitter.withAllGrammars
        nvim-treesitter-textobjects
        lualine-nvim
        which-key-nvim
        gitsigns-nvim
        nvim-tree-lua
        trouble-nvim
        comment-nvim
        nvim-autopairs
        indent-blankline-nvim
      ];

      initLua = ''
        vim.g.mapleader = " "
        vim.g.maplocalleader = " "

        vim.opt.number = true
        vim.opt.relativenumber = true
        vim.opt.termguicolors = true
        vim.opt.mouse = "a"
        vim.opt.clipboard = "unnamedplus"
        vim.opt.splitright = true
        vim.opt.splitbelow = true
        vim.opt.ignorecase = true
        vim.opt.smartcase = true

        require("which-key").setup({})
        require("gitsigns").setup({})
        require("Comment").setup({})
        require("nvim-autopairs").setup({})
        require("lualine").setup({ options = { theme = "auto" } })
        require("nvim-tree").setup({})
        require("trouble").setup({})
        require("ibl").setup({})

        require("telescope").setup({})
        pcall(require("telescope").load_extension, "fzf")

        local lspconfig = require("lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local servers = {
          "bashls", "clangd", "dockerls", "gopls", "lua_ls", "marksman",
          "nixd", "pyright", "rust_analyzer", "taplo", "ts_ls", "yamlls",
          "html", "cssls", "jsonls"
        }
        for _, server in ipairs(servers) do
          lspconfig[server].setup({ capabilities = capabilities })
        end

        local cmp = require("cmp")
        cmp.setup({
          snippet = {
            expand = function(args)
              require("luasnip").lsp_expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping.select_next_item(),
            ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "path" },
            { name = "buffer" },
          }),
        })

        require("nvim-treesitter.configs").setup({
          highlight = { enable = true },
          indent = { enable = true },
        })

        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
        vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
        vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Explorer" })
        vim.keymap.set("n", "<leader>xx", ":Trouble diagnostics toggle<CR>", { desc = "Diagnostics" })
      '';
    };

    ripgrep.enable = true;
    starship.enable = true;
    tealdeer.enable = true;

    tmux = {
      enable = true;
      sensibleOnTop = true;
      clock24 = true;
      keyMode = "vi";
      terminal = "screen-256color";
      historyLimit = 100000;
      extraConfig = ''
        set -g mouse on
        set -g set-clipboard on
        set -g base-index 1
        setw -g pane-base-index 1
        set -g renumber-windows on

        unbind %
        unbind '"'
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"

        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        bind r source-file ~/.config/tmux/tmux.conf \; display-message "tmux config reloaded"
      '';
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
