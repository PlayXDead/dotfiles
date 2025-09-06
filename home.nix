{ pkgs, ... }:

{
  home.username = "tim";
  home.homeDirectory = "/home/tim";
  home.stateVersion = "25.11";

  programs.nix-search-tv.enable = true;

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    extraConfig = ''
      " General Vim settings
      set number
      set relativenumber " disable relative numbers if you want absolute
      set cursorline
      set list
      set termguicolors
      syntax on

      if &diff
        colorscheme blue
      endif

      lua << EOF
        vim.g.mapleader = " "
        local map = vim.keymap.set
        local opts = { silent = true, noremap = true }

        -- Bootstrap lazy.nvim
        local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
        if not vim.loop.fs_stat(lazypath) then
          vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable",
            lazypath,
          })
        end
        vim.opt.rtp:prepend(lazypath)

        -- Load icons
        require("nvim-web-devicons").setup { default = true }

        -- Lazy.nvim plugin setup
        require("lazy").setup({
          { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
          { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },
          { "folke/which-key.nvim" },
          { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
          { "akinsho/toggleterm.nvim" },
          { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
          { "nvim-treesitter/nvim-treesitter-textobjects" },
          { "neovim/nvim-lspconfig" },
          { "hrsh7th/nvim-cmp" },
          { "hrsh7th/cmp-nvim-lsp" },
          { "hrsh7th/cmp-buffer" },
          { "hrsh7th/cmp-path" },
          { "hrsh7th/cmp-cmdline" },
          { "onsails/lspkind.nvim" },
          { "navarasu/onedark.nvim" },
          { "nvim-lua/plenary.nvim" },
        })

        -- NvimTree configuration
        local ok_tree, nvim_tree = pcall(require, "nvim-tree")
        if ok_tree then
          nvim_tree.setup({
            sort_by = "name";
            view = { width = 30; side = "left"; };
            renderer = { icons = { show = { git = true; folder = true; file = true; folder_arrow = true; } }; };
            hijack_netrw = true;
            update_focused_file = { enable = true; update_cwd = true; };
            diagnostics = { enable = true; icons = { hint = ""; info = ""; warning = ""; error = ""; }; };
            git = { enable = true; ignore = false; };
            actions = { open_file = { quit_on_open = false; }; };
          })
        end

        -- NvimTree keybinding
        map("n", "<leader>e", function()
          local ok, api = pcall(require, "nvim-tree.api")
          if ok then api.tree.toggle() end
        end, opts)

        -- ToggleTerm keybinding
        map("n", "<leader>h", function()
          local ok, toggleterm = pcall(require, "toggleterm")
          if ok then require("toggleterm").toggle() end
        end, opts)

        -- Exit terminal mode with Esc
        map("t", "<Esc>", "<C-\\><C-n>", opts)

        -- Telescope keybindings
        map("n", "<leader>ff", function() require("telescope.builtin").find_files() end, opts)
        map("n", "<leader>fa", function() require("telescope.builtin").find_files({ follow=true; no_ignore=true; hidden=true; }) end, opts)
        map("n", "<leader>fw", function() require("telescope.builtin").live_grep() end, opts)
        map("n", "<leader>fb", function() require("telescope.builtin").buffers() end, opts)
        map("n", "<leader>fh", function() require("telescope.builtin").help_tags() end, opts)

        -- Windows & Tabs
        map("n", "<leader>sv", "<C-w>v", opts)
        map("n", "<leader>sh", "<C-w>s", opts)
        map("n", "<leader>se", "<C-w>=", opts)
        map("n", "<leader>sx", ":close<CR>", opts)
        map("n", "<leader>to", ":tabnew<CR>", opts)
        map("n", "<leader>tx", ":tabclose<CR>", opts)
        map("n", "<leader>tn", ":tabn<CR>", opts)
        map("n", "<leader>tp", ":tabp<CR>", opts)

        -- Save / Quit
        map("n", "<leader>w", ":w<CR>", opts)
        map("n", "<leader>q", ":q<CR>", opts)
        map("n", "<leader>Q", ":qa!<CR>", opts)

        -- LSP keymaps
        map("n", "gd", vim.lsp.buf.definition, opts)
        map("n", "K", vim.lsp.buf.hover, opts)
        map("n", "gi", vim.lsp.buf.implementation, opts)
        map("n", "gr", vim.lsp.buf.references, opts)
        map("n", "<leader>rn", vim.lsp.buf.rename, opts)
        map("n", "<leader>ca", vim.lsp.buf.code_action, opts)

        -- Treesitter setup
        local parser_dir = vim.fn.stdpath("data") .. "/nvim-treesitter-parsers"
        vim.opt.runtimepath:append(parser_dir)
        require'nvim-treesitter.configs'.setup {
          ensure_installed = { "nix"; "lua"; "python"; "bash"; "json"; "markdown"; "javascript"; "typescript"; "dart"; };
          highlight = { enable = true; };
          incremental_selection = { enable = true; };
          indent = { enable = true; };
          parser_install_dir = parser_dir;
        }

	-- Update/install parsers synchronously
        require'nvim-treesitter.install'.update({ with_sync = true })


        -- LSP servers
        local lspconfig = require('lspconfig')
        lspconfig.lua_ls.setup{}
        lspconfig.pyright.setup{}
        lspconfig.ts_ls.setup{}
        lspconfig.dartls.setup{}
        lspconfig.bashls.setup{}
	cmd = { "/home/tim/.nix-profile/bin/nil" }


        -- Nix LSP (nil)
        lspconfig.nil_ls.setup{
            -- optional settings
            -- cmd = { "nil" }, -- usually automatically found in PATH via Home Manager
            filetypes = { "nix" },
            root_dir = lspconfig.util.root_pattern("flake.nix", "default.nix", ".git"),
        }

EOF
    '';

    plugins = with pkgs.vimPlugins; [
      LazyVim
      lualine-nvim
      nvim-web-devicons
      toggleterm-nvim
      telescope-nvim
      plenary-nvim
      nvim-treesitter
      nvim-treesitter-textobjects
      which-key-nvim
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      lspkind-nvim
      onedark-nvim
    ];
  };

  home.packages = with pkgs; [
    ripgrep
    fd
    fzf
    tree-sitter
    nodejs
    python3
    dart
    lua-language-server
    typescript-language-server
    bash-language-server
    pyright
    android-studio
    nil
  ];
  
  nixpkgs.config.allowUnfree = true;
}

