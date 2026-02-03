{ config, pkgs, ... }:

{
  imports = [
    ./neovim.nix
  ];

  home.username = "tim";
  home.homeDirectory = "/home/tim";
  home.stateVersion = "25.05";

  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic"; # Or the name of your chosen theme
    size = 14;
  };

  #===============================================================
  #PROGRAMS
  #===============================================================

  #==================================================================================
  #SERVICES
  #==================================================================================

  #======================================================================================
  #PACKAGES
  #======================================================================================
  home.packages = with pkgs; [
    (builtins.getFlake "path:/home/tim/OSC").packages.${pkgs.system}.default
    tmux
    fd
    tree-sitter
    nodejs
    lua-language-server
    typescript-language-server
    bash-language-server
    pyright
    nil
    marksman
    firefox
    brave
    tree
    gnome-software
    swww
    nwg-drawer
    waybar
    waypaper
    swaybg
    exfatprogs
    gparted
    gnome-disk-utility
    qemu
    libguestfs
    guestfs-tools
    OVMFFull
    dnsmasq
    cpuset
    rofi
    prismlauncher
    fzf
    tlrc
    neofetch
    cmatrix
    findutils
    radeontop
    mediawriter
    nmap
    gh
    keepass
    easyeffects
    openvpn
    lutris
    winetricks
    tor-browser
    #anki
    libreoffice-fresh
    thunderbird
    nitrogen
    jq
    file-roller
    shotwell
    nautilus
    lxappearance
    flameshot
    vlc
    ranger
    speedtest-cli
    axel
    lsd
    ffmpeg
    ncdu
    teams-for-linux
    fwknop
    wireguard-tools
    bottles
    pdfarranger
    googleearth-pro
    devbox
    vrc-get
    openvr
    bs-manager
    xmind
    zoxide
    vscode
    dunst
    ripgrep
    stylua
    wireshark
    pulseaudio
    glow #view markdown  in the terminal  
    via
    youtube-tui
    fuzzel #fzf app picker for wayland
    gradia#screenshot tool
    xwayland-satellite
    unityhub
    vrc-get
    obsidian
    web-ext #manage & sign browser extensions
    tty-clock #terminal clock
    chromium
    furmark
    liquidctl
    nvtopPackages.amd
    wl-clipboard
    hollywood
    vrcx
    distrobox
    vivaldi
    protonvpn-gui
    httpie # replace curl for cleaner jq like output
    postman
    gnome-pomodoro
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "googleearth-pro-7.3.6.10201"
    "electron-25.9.0"
  ];

  #======================================================================================
  #ALACRITTY TERMINAL CONFIGURATION
  #======================================================================================
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          family = "JetBrains Mono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "JetBrains Mono Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "JetBrains Mono Nerd Font";
          style = "Italic";
        };
        bold_italic = {
          family = "JetBrains Mono Nerd Font";
          style = "Bold Italic";
        };
        size = 12;
      };
      
      env = {
        TERM = "alacritty";
      };
      
      window = {
        opacity = 0.95;
        blur = true;
        padding = {
          x = 6;
          y = 6;
        };
      };
      
      colors = {
        primary = {
          background = "#212337";
          foreground = "#ebfafa";
        };
        normal = {
          black = "#37384d";
          red = "#f16c75";
          green = "#04d1f9";
          yellow = "#f1fc79";
          blue = "#7081d0";
          magenta = "#a48cf2";
          cyan = "#04d1f9";
          white = "#ebfafa";
        };
        bright = {
          black = "#323449";
          red = "#f16c75";
          green = "#04d1f9";
          yellow = "#f1fc79";
          blue = "#7081d0";
          magenta = "#a48cf2";
          cyan = "#04d1f9";
          white = "#ebfafa";
        };
      };
      
      cursor = {
        style = {
          shape = "Beam";
          blinking = "On";
        };
        blink_interval = 500;
      };
    };
  };

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    Unit = {
      Description = "polkit-gnome-authentication-agent-1";
      Wants = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
