{ pkgs, ... }:

{
  home.username = "tim";
  home.homeDirectory = "/home/tim";
  home.stateVersion = "25.05";

#===============================================================
	#PROGRAMS
#===============================================================
  programs.nix-search-tv.enable = true;


#==================================================================================
		#SERVICES
#==================================================================================
  services.ollama = {
    enable = true;
    port = 11434;
    acceleration = "cuda";
    environmentVariables = {
      OLLAMA_FLASH_ATTENTION="True";
      OLLAMA_KV_CACHE_TYPE="f16";
    };  
  };

#======================================================================================
	#PACKAGES
#======================================================================================

  home.packages = with pkgs; [
    fd
    tree-sitter
    nodejs
    dart
    lua-language-server
    typescript-language-server
    bash-language-server
    pyright
    nil
    marksman
    aider-chat
    firefox
    brave
    tree
    discord
    gnome-software
    swww
    nwg-drawer
    waybar
    waypaper
    swaybg
    exfatprogs
    gparted
    gnome-disk-utility
    looking-glass-client
    qemu
    libguestfs #tool to modify vm
    guestfs-tools #tool to modify vm
    OVMFFull#enable secure boot for QEMU
    dnsmasq
    cpuset
    rofi
    prismlauncher
    gccgo# C compiler
    fzf #Fuzzy finder for term
    tlrc
    neofetch
    cmatrix
    findutils
    nvtopPackages.full
    mediawriter
    nmap
    #vagrant
    gh #git hub cli
    #rpcs3 #Ps3 emulator
    #pcsx2 #PS2 emulator
    obsidian #Powerful Notes Application
    #packer #packaging tool. Used for metasploitable build
    keepass
    hyprlock#screen locking utility
    easyeffects
    openvpn
    lutris
    winetricks
    tor-browser
    libsForQt5.okular
    anki
    distrobox
    libreoffice-fresh
    thunderbird
    nitrogen #X11 wallpaper gui
    jq #use with javascript responses over grep
    gimp
    rawtherapee
    #ciscoPacketTracer8
    file-roller#GUI based decompression utility
    shotwell #import photos. issues with nvidia on wayland
    #zoom-us
    nautilus#Gnome file explorer
    lxappearance # configure the appearance of GTK themed apps
    kdePackages.kcalc#kde calculator
    appimage-run
    flameshot
    vlc
    ranger #cli file manager
    speedtest-cli
    axel #file downloader by splitting download into multiple channelsf
    lsd #better version of ls command
    ffmpeg
    ncdu # analyze/manage disk usage
    flowtime # work efficiently
    mousam # weather app
    teams-for-linux# teams app for linux
    teamspeak_client
    stacer # system monitor and cleaner
    fwknop #Single Packet Authorization (and Port Knocking) server/client
    wireguard-tools #tools for wireguard vpn
    bottles
    pdfarranger
    googleearth-pro
    qgis-ltr
    devbox
    vrc-get
    #unityhub
    wlx-overlay-s
    blender
    bs-manager #beatsaber manager
    hyprshot
    xmind
    zoxide
    vscode
    dunst #notificatino daemon
    ripgrep #Used by Telescope for fuzzy finding
    stylua #Lua formatter [1.1]
    xclip #tool to acces the X clipboard from a console application
    wireshark
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "googleearth-pro-7.3.6.10201"
    "electron-25.9.0"
  ];

#=======================================================================================
	#NEOVIM
#=======================================================================================
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    plugins = with pkgs.vimPlugins; [
      lualine-nvim
      nvim-web-devicons
      toggleterm-nvim
      telescope-nvim
      plenary-nvim
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
      ]))
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
      tokyonight-nvim
      nvim-tree-lua
      (pkgs.vimUtils.buildVimPlugin {
        pname = "eldritch-nvim";
	version = "2024-09-01"; # or latest commit date
	  src = pkgs.fetchFromGitHub {
	    owner = "eldritch-theme";
	    repo = "eldritch.nvim";
	    rev = "c980caea40cab7eab2c3a467af5bab1e7e66fcce"; # or a commit hash for reproducibility
	    sha256 = "sha256-jfxCX73BK/Px/OkcC2st2KjXqd/S9+F9aVIKyJLOB0o=";
	  };
        })
      ];
      extraConfig = ''
	" General Vim settings
        set number
	set cursorline
	set list
	set termguicolors
	syntax on

	" =======================
	" THEME
	" =======================
        lua << EOF
	  require("eldritch").setup({
	    transparent = false,
	    styles = {
	      comments = "italic",
	      keywords = "bold",
	      functions = "NONE",
	      variables = "NONE",
	    },
	  })
	  vim.cmd("colorscheme eldritch")

	  -- =================================================================
	  -- CORE SETUP
	  -- =================================================================
	  vim.g.mapleader = " "
	  local map = vim.keymap.set
	  local opts = { silent = true, noremap = true }
  
	  -- =================================================================
	  -- PLUGIN CONFIGURATIONS
	  -- =================================================================
	  require("nvim-web-devicons").setup { default = true }
	  require("nvim-tree").setup{
	      sort_by = "name",
	      view = { width = 30, side = "left" },
	      renderer = { icons = { show = { git = true, folder = true, file = true, folder_arrow = true } } },
	      hijack_netrw = true,
	      update_focused_file = { enable = true, update_cwd = true },
	  }
	  require('lualine').setup { options = { theme = 'eldritch' } }
	  require'nvim-treesitter.configs'.setup ({
	    highlight = { enable = true },
	    incremental_selection = { enable = true },
	    indent = { enable = true },
  	  })

	  -- =================================================================
	  -- OLLAMA INTEGRATION (PLENARY)
	  -- =================================================================
	  package.preload["ollama"] = function()
	    return dofile(vim.fn.stdpath("config") .. "/lua/ollama.lua")
	  end
	  vim.api.nvim_set_keymap("i", "<C-g>", "<cmd>lua require'ollama'.complete()<CR>", { noremap = true, silent = true })

	  -- =================================================================
	  -- LAZY-LOADED LSP CONFIGURATION
	  -- =================================================================
	  vim.api.nvim_create_autocmd("FileType", {
	    pattern = { "nix", "lua", "python", "bash", "json", "markdown", "javascript", "typescript", "dart" },
	    callback = function(event)
 	    local buf = event.buf
	    local filetype = vim.bo[buf].filetype
	    local lspconfig = require('lspconfig')
	    local map_buf = function(key, func)
	    vim.keymap.set('n', key, func, { silent = true, noremap = true, buffer = buf })
	  end

	  map_buf('K', vim.lsp.buf.hover)
	  map_buf('gd', vim.lsp.buf.definition)
	  map_buf('<leader>ca', vim.lsp.buf.code_action)

 	  if filetype == "nix" then lspconfig.nil_ls.setup({})
  	    elseif filetype == "lua" then lspconfig.lua_ls.setup({})
	    elseif filetype == "python" then lspconfig.pyright.setup({})
	    elseif filetype == "bash" then lspconfig.bashls.setup({})
	    elseif filetype == "json" then lspconfig.jsonls.setup({})
	    elseif filetype == "markdown" then lspconfig.marksman.setup({})
	    elseif filetype == "javascript" or filetype == "typescript" then lspconfig.tsserver.setup({})
	    elseif filetype == "dart" then lspconfig.dartls.setup({})
	        end
	      end,
	    })

	    -- =================================================================
	    -- KEYMAPS
	    -- =================================================================
	    map("n", "<leader>e", require("nvim-tree.api").tree.toggle, opts)
	    map("n", "<leader>h", function() require("toggleterm").toggle() end, opts)
	    map("t", "<Esc>", "<C-\\><C-n>", opts)
	    map("n", "<leader>ff", function() require("telescope.builtin").find_files() end, opts)
	    map("n", "<leader>fw", function() require("telescope.builtin").live_grep() end, opts)
	    map("n", "<leader>w", ":w<CR>", opts)
	    map("n", "<leader>q", ":q<CR>", opts)
	    map("n", "<leader>Q", ":qa!<CR>", opts)
EOF
      '';
  };
}  

