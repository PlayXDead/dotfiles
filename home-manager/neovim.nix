#=======================================================================================
#NEOVIM - ENHANCED FLUTTER DEVELOPMENT
#=======================================================================================
{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    
    plugins = with pkgs.vimPlugins; [
      # UI and Navigation
      lualine-nvim
      nvim-web-devicons
      toggleterm-nvim
      telescope-nvim
      plenary-nvim
      which-key-nvim
      nvim-tree-lua
      
      # Enhanced Treesitter with more parsers
      (nvim-treesitter.withPlugins (p: [
        p.nix
        p.lua
        p.python
        p.bash
        p.json
        p.markdown
        p.javascript
        p.typescript
        p.dart
        p.yaml
        p.html
        p.css
        p.scss
        p.regex
        p.vim
      ]))
      nvim-treesitter-textobjects
      
      # LSP and Completion
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-nvim-lsp-signature-help
      lspkind-nvim
      
      # Flutter/Dart specific
      flutter-tools-nvim
      
      # Themes
      onedark-nvim
      tokyonight-nvim
      (pkgs.vimUtils.buildVimPlugin {
        pname = "eldritch-nvim";
        version = "2024-09-01";
        src = pkgs.fetchFromGitHub {
          owner = "eldritch-theme";
          repo = "eldritch.nvim";
          rev = "c980caea40cab7eab2c3a467af5bab1e7e66fcce";
          sha256 = "sha256-jfxCX73BK/Px/OkcC2st2KjXqd/S9+F9aVIKyJLOB0o=";
        };
      })
      
      # Snippets for templates
      luasnip
      cmp_luasnip
      friendly-snippets
      
      # Additional helpful plugins
      indent-blankline-nvim
      gitsigns-nvim
      comment-nvim
      nvim-autopairs
      vim-surround
      
      # Code formatting
      null-ls-nvim
    ];

    extraConfig = ''
      " General Vim settings
      set number
      set relativenumber
      set cursorline
      set list
      set termguicolors
      set expandtab
      set tabstop=2
      set shiftwidth=2
      set softtabstop=2
      set smartindent
      set wrap
      set scrolloff=8
      set signcolumn=yes
      set updatetime=50
      set colorcolumn=80
      
      " Font and terminal improvements for better styling support
      set t_ZH=[3m  " Enable italic mode
      set t_ZR=[23m " Disable italic mode
      set t_Cs=\e[4:3m " Enable undercurl
      set t_Ce=\e[4:0m " Disable undercurl
      
      " Ensure proper terminal capabilities
      if has('nvim')
        let $NVIM_TUI_ENABLE_TRUE_COLOR=1
        let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
      endif
      
      syntax on

      " ======================= 
      " THEME WITH ENHANCED FONT STYLING
      " =======================
      lua << EOF
      require("eldritch").setup({
        transparent = false,
        styles = {
          comments = { italic = true },
          keywords = { bold = true, italic = true },
          functions = { italic = true },
          variables = {},
          sidebars = "dark",
          floats = "dark",
        },
        -- Enable italic comments and keywords
        italic_comments = true,
        italic_keywords = true,
        italic_functions = true,
        italic_variables = false,
      })
      
      -- Apply theme
      vim.cmd("colorscheme eldritch")
      
      -- Force italic styling for specific highlight groups after theme loads
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          -- Comments should be italic
          vim.api.nvim_set_hl(0, "Comment", { italic = true, fg = "#7C7C7C" })
          
          -- Keywords should be bold and italic
          vim.api.nvim_set_hl(0, "Keyword", { bold = true, italic = true })
          vim.api.nvim_set_hl(0, "Statement", { bold = true, italic = true })
          vim.api.nvim_set_hl(0, "Conditional", { bold = true, italic = true })
          vim.api.nvim_set_hl(0, "Repeat", { bold = true, italic = true })
          
          -- Functions should be italic
          vim.api.nvim_set_hl(0, "Function", { italic = true })
          
          -- Types should be italic
          vim.api.nvim_set_hl(0, "Type", { italic = true })
          vim.api.nvim_set_hl(0, "TypeDef", { italic = true })
          
          -- String styling
          vim.api.nvim_set_hl(0, "String", { italic = true })
          
          -- Operators
          vim.api.nvim_set_hl(0, "Operator", { bold = true })
        end,
      })
      
      -- Trigger the autocmd for current colorscheme
      vim.cmd("doautocmd ColorScheme")

      -- =================================================================
      -- CORE SETUP
      -- =================================================================
      vim.g.mapleader = " "
      local map = vim.keymap.set
      local opts = { silent = true, noremap = true }

      -- =================================================================
      -- ENHANCED COMPLETION SETUP
      -- =================================================================
      local cmp = require'cmp'
      local luasnip = require'luasnip'
      local lspkind = require'lspkind'

      -- Load friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = 'symbol',
            maxwidth = 50,
            ellipsis_char = '...',
          }),
        },
      })

      -- =================================================================
      -- FLUTTER WIDGET SNIPPETS
      -- =================================================================
      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node
      
      ls.add_snippets("dart", {
        -- StatelessWidget template
        s("stless", {
          t({"class "}), i(1, "MyWidget"), t({" extends StatelessWidget {", 
            "  const "}), i(2, "MyWidget"), t({"({Key? key}) : super(key: key);", 
            "", 
            "  @override", 
            "  Widget build(BuildContext context) {", 
            "    return "}), i(3, "Container()"), t({";", 
            "  }", 
            "}"}),
        }),
        
        -- StatefulWidget template
        s("stful", {
          t({"class "}), i(1, "MyWidget"), t({" extends StatefulWidget {", 
            "  const "}), i(2, "MyWidget"), t({"({Key? key}) : super(key: key);", 
            "", 
            "  @override", 
            "  State<"}), i(3, "MyWidget"), t({"> createState() => _"}), i(4, "MyWidget"), t({"State();", 
            "}", 
            "", 
            "class _"}), i(5, "MyWidget"), t({"State extends State<"}), i(6, "MyWidget"), t({"> {", 
            "  @override", 
            "  Widget build(BuildContext context) {", 
            "    return "}), i(7, "Container()"), t({";", 
            "  }", 
            "}"}),
        }),
        
        -- Scaffold template
        s("scaffold", {
          t({"Scaffold(", 
            "  appBar: AppBar(", 
            "    title: Text('"}), i(1, "Title"), t({"'),", 
            "  ),", 
            "  body: "}), i(2, "Container()"), t({",", 
            ")"}),
        }),
        
        -- Column template
        s("column", {
          t({"Column(", 
            "  children: [", 
            "    "}), i(1, "Container()"), t({",", 
            "  ],", 
            ")"}),
        }),
        
        -- Row template
        s("row", {
          t({"Row(", 
            "  children: [", 
            "    "}), i(1, "Container()"), t({",", 
            "  ],", 
            ")"}),
        }),
        
        -- Container template
        s("container", {
          t({"Container(", 
            "  width: "}), i(1, "100"), t({",", 
            "  height: "}), i(2, "100"), t({",", 
            "  decoration: BoxDecoration(", 
            "    color: "}), i(3, "Colors.blue"), t({",", 
            "  ),", 
            "  child: "}), i(4, "Text('Hello')"), t({",", 
            ")"}),
        }),
      })

      -- =================================================================
      -- PLUGIN CONFIGURATIONS
      -- =================================================================
      require("nvim-web-devicons").setup {
        default = true
      }

      require("nvim-tree").setup{
        sort_by = "name",
        view = {
          width = 30,
          side = "left"
        },
        renderer = {
          icons = {
            show = {
              git = true,
              folder = true,
              file = true,
              folder_arrow = true
            }
          }
        },
        hijack_netrw = true,
        update_focused_file = {
          enable = true,
          update_cwd = true
        },
      }

      require('lualine').setup {
        options = {
          theme = 'eldritch'
        }
      }

      require'nvim-treesitter.configs'.setup {
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        incremental_selection = {
          enable = true,
        },
        indent = {
          enable = true,
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
        },
      }

      -- Additional helpful plugins
      require('gitsigns').setup()
      require('Comment').setup()
      require('nvim-autopairs').setup()
      
      -- Indent-blankline v3 setup
      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      }
      local hooks = require "ibl.hooks"
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)
      
      require("ibl").setup {
        indent = {
          highlight = highlight,
          char = "│",
        },
        scope = {
          enabled = true,
          show_start = true,
          show_end = true,
        }
      }

      -- =================================================================
      -- ENHANCED FLUTTER TOOLS SETUP (Environment Agnostic)
      -- =================================================================
      -- Function to detect Flutter/Dart installation
      local function find_dart_lsp()
        local dart_paths = {
          vim.fn.exepath("dart"),  -- Check PATH first (works in nix develop)
          "/usr/bin/dart",         -- System installation
          "/usr/local/bin/dart",   -- Homebrew/manual install
          vim.fn.expand("~/fvm/default/bin/dart"), -- FVM
        }
        
        for _, path in ipairs(dart_paths) do
          if path and path ~= "" and vim.fn.executable(path) == 1 then
            return path
          end
        end
        return nil
      end

      local dart_path = find_dart_lsp()
      
      require("flutter-tools").setup{
        ui = {
          border = "rounded",
          notification_style = dart_path and 'plugin' or 'native',
        },
        decorations = {
          statusline = {
            app_version = dart_path and true or false,
            device = dart_path and true or false,
          }
        },
        debugger = {
          enabled = false,
        },
        flutter_path = vim.fn.exepath("flutter"), -- Use PATH lookup
        flutter_lookup_cmd = nil, -- Let it auto-detect
        fvm = false,
        dart_define = {},
        dart_define_from_file = "",
        widget_guides = {
          enabled = dart_path and true or false,
        },
        closing_tags = {
          highlight = "Comment",
          prefix = "// ",
          enabled = dart_path and true or false
        },
        dev_log = {
          enabled = dart_path and true or false,
          notify_errors = false,
          open_cmd = "tabedit",
        },
        dev_tools = {
          autostart = false,
          auto_open_browser = false,
        },
        outline = {
          open_cmd = "30vnew",
          auto_open = false
        },
        lsp = dart_path and {
          color = {
            enabled = true,
            background = false,
            foreground = false,
            virtual_text = true,
            virtual_text_str = "■",
          },
          cmd = { dart_path, "language-server", "--protocol=lsp" },
          on_attach = function(client, bufnr)
            local map = vim.keymap.set
            local opts = { buffer = bufnr, noremap = true, silent = true }
            
            -- Flutter specific commands
            map("n", "<leader>fr", "<cmd>FlutterRun<CR>", opts)
            map("n", "<leader>fq", "<cmd>FlutterQuit<CR>", opts) 
            map("n", "<leader>fd", "<cmd>FlutterDevices<CR>", opts)
            map("n", "<leader>fl", "<cmd>FlutterLogToggle<CR>", opts)
            map("n", "<leader>R", "<cmd>FlutterHotReload<CR>", opts)
            map("n", "<leader>fR", "<cmd>FlutterRestart<CR>", opts)
            map("n", "<leader>fo", "<cmd>FlutterOutlineToggle<CR>", opts)
            map("n", "<leader>ft", "<cmd>FlutterDevTools<CR>", opts)
            map("n", "<leader>fc", "<cmd>FlutterLogClear<CR>", opts)
            
            -- LSP keymaps
            map('n', 'K', vim.lsp.buf.hover, opts)
            map('n', 'gd', vim.lsp.buf.definition, opts)
            map('n', '<leader>ca', vim.lsp.buf.code_action, opts)
            map('n', '<leader>rn', vim.lsp.buf.rename, opts)
            map('n', 'gr', vim.lsp.buf.references, opts)
          end,
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            analysisExcludedFolders = {
              vim.fn.expand("$HOME/AppData/Local/Pub/Cache"),
              vim.fn.expand("$HOME/.pub-cache"),
              vim.fn.expand("$HOME/Tools/flutter"),
            },
            renameFilesWithClasses = "prompt",
            enableSnippets = true,
          }
        } or {
          -- Fallback when no dart is available
          on_attach = function(client, bufnr)
            -- Show a message that Flutter tools are limited
            vim.notify("Dart LSP not available. Enter your Flutter dev environment for full features.", vim.log.levels.WARN)
          end
        }
      }

      -- =================================================================
      -- WHICH-KEY SETUP FOR FLUTTER SHORTCUTS (Environment Aware)
      -- =================================================================
      local wk = require("which-key")
      
      -- Check if we're in a Flutter environment
      local has_flutter = vim.fn.executable("flutter") == 1
      local has_dart = dart_path ~= nil
      
      if has_flutter and has_dart then
        -- Full Flutter development mappings
        wk.add({
          { "<leader>f", group = "Flutter" },
          { "<leader>fr", "<cmd>FlutterRun<cr>", desc = "Run" },
          { "<leader>fq", "<cmd>FlutterQuit<cr>", desc = "Quit" },
          { "<leader>fd", "<cmd>FlutterDevices<cr>", desc = "Devices" },
          { "<leader>fl", "<cmd>FlutterLogToggle<cr>", desc = "Log Toggle" },
          { "<leader>fR", "<cmd>FlutterRestart<cr>", desc = "Restart" },
          { "<leader>fo", "<cmd>FlutterOutlineToggle<cr>", desc = "Outline Toggle" },
          { "<leader>ft", "<cmd>FlutterDevTools<cr>", desc = "Dev Tools" },
          { "<leader>fc", "<cmd>FlutterLogClear<cr>", desc = "Clear Log" },
          { "<leader>s", group = "Snippets/Templates" },
          { "<leader>ss", function() require('luasnip').expand_or_jump() end, desc = "Expand Snippet", mode = "i" },
          { "<leader>sl", "<cmd>LuaSnipListAvailable<cr>", desc = "List Snippets" },
          { "<leader>fe", function() 
            vim.notify("Flutter environment: ✅ Active (dart: " .. dart_path .. ")", vim.log.levels.INFO)
          end, desc = "Check Flutter Env" },
        })
      else
        -- Limited mappings when Flutter is not available
        wk.add({
          { "<leader>f", group = "Flutter (Limited)" },
          { "<leader>fe", function() 
            local status = "❌ Not in Flutter dev environment"
            if has_flutter then
              status = status .. "\n✅ Flutter found: " .. vim.fn.exepath("flutter")
            else
              status = status .. "\n❌ Flutter not found in PATH"
            end
            if has_dart then
              status = status .. "\n✅ Dart found: " .. dart_path
            else
              status = status .. "\n❌ Dart not found in PATH"
            end
            status = status .. "\n\n💡 Run 'nix develop' in your Flutter project to activate full features"
            vim.notify(status, vim.log.levels.WARN)
          end, desc = "Check Flutter Env" },
          { "<leader>s", group = "Snippets/Templates" },
          { "<leader>ss", function() require('luasnip').expand_or_jump() end, desc = "Expand Snippet", mode = "i" },
          { "<leader>sl", "<cmd>LuaSnipListAvailable<cr>", desc = "List Snippets" },
        })
      end

      -- =================================================================
      -- LSP CONFIGURATION
      -- =================================================================
      vim.lsp.enable({'nil_ls', 'lua_ls', 'pyright', 'bashls', 'jsonls', 'marksman', 'ts_ls'})

      -- Configure lua_ls with custom settings
      vim.lsp.config.lua_ls = {
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' }
            }
          }
        }
      }

      -- =================================================================
      -- GENERAL KEYMAPS
      -- =================================================================
      map("n", "<leader>e", require("nvim-tree.api").tree.toggle, opts)
      map("n", "<leader>h", function() require("toggleterm").toggle() end, opts)
      map("t", "<Esc>", "<C-\\><C-n>", opts)
      map("n", "<leader>ff", function() require("telescope.builtin").find_files() end, opts)
      map("n", "<leader>fw", function() require("telescope.builtin").live_grep() end, opts)
      map("n", "<leader>fb", function() require("telescope.builtin").buffers() end, opts)
      map("n", "<leader>fh", function() require("telescope.builtin").help_tags() end, opts)
      
      -- File operations
      map("n", "<leader>w", ":w<CR>", opts)
      map("n", "<leader>q", ":q<CR>", opts)
      map("n", "<leader>Q", ":qa!<CR>", opts)
      
      -- Better navigation
      map("n", "<C-d>", "<C-d>zz", opts)
      map("n", "<C-u>", "<C-u>zz", opts)
      map("n", "n", "nzzzv", opts)
      map("n", "N", "Nzzzv", opts)
      
      -- Move lines
      map("v", "J", ":m '>+1<CR>gv=gv", opts)
      map("v", "K", ":m '<-2<CR>gv=gv", opts)

      -- Keep visual selection when indenting
      map("v", "<", "<gv", opts)
      map("v", ">", ">gv", opts)
      
      EOF
    '';
  };
}
