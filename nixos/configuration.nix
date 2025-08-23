# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./user.nix
      ./secrets.nix
      ./virtualization.nix
      ./environment.nix
      #./vr.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  
  nix.settings = {
    experimental-features = [ 
      "nix-command"
      "flakes" 
    ];
  };

  boot.loader = {
    efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot"; # ← use the same mount point here.
    };
    grub = {
       efiSupport = true;
       #efiInstallAsRemovable = true; # in case canTouchEfiVariables doesn't work for your system
       device = "nodev";
    };
  };
  boot.kernelPackages = pkgs.linuxPackages_latest;

  #Extra Kernel Modules - v4l2loopback
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  networking.hostName = "PlayWasHere"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Detroit";
  #services.automatic-timezoned.enable = true;
  services.ntp.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
   i18n.defaultLocale = "en_US.UTF-8";
    console = {
    font = "Lat2-Terminus16";
     #keyMap = "us";
     useXkbConfig = true; # use xkbOptions in tty.
   };

  #Load GPU DRIVERS Early
  boot.initrd.kernelModules = [ 
    "nvidia"
  ];

  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.kernelModules = [ 
    "nvidia"
    "v4l2loopback"
  ];

  #Improve memory performance for games & windows applications using Wine/Proton
  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;
  };

  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';
  security.polkit.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  #Nvidia Drivers
  hardware.nvidia = {

  # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
   
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  hardware.graphics = {
  ## radv: an open-source Vulkan driver from freedesktop
    enable = true;
  };

  # Configure keymap in X11
   services.xserver.xkb.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  #sound.enable = true;
  #hardware.pulseaudio.enable = true;
  #hardware.pulseaudio.support32Bit = true;
  
  # Enable Pipewire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.jack = {
    jackd.enable = true;
    # support ALSA only programs via ALSA JACK PCM plugin
    alsa.enable = false;
    # support ALSA only programs via loopback device (supports programs like Steam)
    loopback = {
      enable = true;
      # buffering parameters for dmix device to work with ALSA only semi-professional sound programs
      #dmixConfig = ''
      #  period_size 2048
      #'';
    };
  };


  #services.pipewire.extraConfig.pipewire-pulse = {
  #  "10-clock-rate" = {
  #  "context.properties" = {
  #    "default.clock.rate" = 48000;
  #    };
  #  };
  #};  

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    cups-pdf = {
      enable = true;
      instances.pdf.settings = {
        Out = "/home/tim/Work/prints";
      };
    };  
  };

  # Disable Root User Password
  users.users.root.hashedPassword = "!";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    nano
    pavucontrol
    alacritty
    networkmanagerapplet
    #nodejs_21
    btop
    tmux
    libsForQt5.qt5.qtwayland
    libsForQt5.qt5ct
    libva
    gitFull
    usbutils
    coreutils-full
    udiskie # auto mount usb devices
    zip
    unzip
    wireshark
    bat
    eza
    playerctl #media controller necessary to add keyboard media functionality
    nix-index # tool to help find things such as config files on nix. ex: nix-locate polybar/config
    busybox # list of critical system tools.
    #polkit_gnome
    lxqt.lxqt-policykit#polkit agent
    snort # intrusion detection
    gphoto2
    openvr
    opencomposite
  ];

  nixpkgs.config.allowBroken = true;

  #neovim
  programs.neovim = {
    viAlias = true;
    vimAlias = true;
    enable = true;
    defaultEditor = true;
    #configure = {
      #customRC = ''
        #set number
	#let NERDTreeShowHidden=1
        #set cc=80
        #set list
	#nmap <F6> :NERDTreeToggle<CR>
        #set listchars=tab:→\ ,space:·,nbsp:␣,trail:•,eol:¶,precedes:«,extends:»
        #if &diff
        #  colorscheme blue
        #endif
      #'';
      #packages.myVimPackage = with pkgs.vimPlugins; {
        #start = [ 
          #ctrlp
    	  #nerdtree
	  #nvim-autopairs
	  #comment-nvim
	  #toggleterm-nvim
	  #nvchad dependencies start
	  #nvchad
	  #nvchad-ui
	  #which-key-nvim
	  #base46
  	  #nvterm
	  #nvim-tree-lua
	  #nvim-web-devicons
	  #gitsigns-nvim
	  #nvim-lspconfig
	  #mason-nvim
	  #nvim-cmp
	  #telescope-nvim
	  #nvim-treesitter
	  #nvim-autopairs
	  #indent-blankline-nvim
	  #friendly-snippets
	  #luasnip
	  #nvchad dependencies stop
	  #nvim-whichkey-setup-lua
	  #LazyVim
       #];
      #};
    #};
  };


  #Whitelist Unfree
  nixpkgs.config.allowUnfree = true;

  #Allow insecure app
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0" #Required for Obsidian
    "googleearth-pro-7.3.6.10201"
    ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
   programs.mtr.enable = true;
   programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };

  #Fonts
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
  ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  fonts.fontDir.enable = true;

  #Java
  programs.java.enable = true; 

  #Steam Stuff
  programs.steam = {
  enable = true;
  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  programs.steam.gamescopeSession.enable = true;

  programs.gamemode.enable = true;

  services.teamviewer.enable = true;



  #obs
  programs.obs-studio.package = (pkgs.obs-studio.override {
    cudaSupport = true;
  });

    programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-source-clone
      obs-shaderfilter
      obs-move-transition
    ];
  };

  programs.obs-studio.enableVirtualCamera = true;
  
  #LLM
  services.ollama = {
    enable = true;
    loadModels = [
      gemma3:latest
    ];
  };  

  services.open-webui = {
    enable = true;
    environment = {
      #makes available on the network
      OPENWEBUI_HOST = "0.0.0.0";
      ANONYMIZED_TELEMETRY = "False";
      DO_NOT_TRACK = "True";
      SCARF_NO_ANALYTICS = "True";
      # Disable authentication
      WEBUI_AUTH = "False";
      #ensure utilization of gpu
      TF_FORCE_GPU_ALLOW_GROWTH = "True";
      CUDA_VISIBLE_DEVICES = "0"; # Replace with your desired GPU index(es)
    };
  };


    # List services that you want to enable:
  nix.settings.auto-optimise-store = true;


  #Flatpak
  services.flatpak.enable = true;

  xdg.portal = {
    enable = true;
    #extraPortals = [ 
    #  ];
    wlr.enable = true;
    xdgOpenUsePortal = true;
  };

    #wireshark
  programs.wireshark.enable = true;

  #Authenticator
  systemd = {
  user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  services.fail2ban = {
    enable = true;
   # Ban IP after 5 failures
    maxretry = 5;
    ignoreIP = [
      # Whitelist some subnets
      #"10.0.0.0/8" "172.16.0.0/12" "192.168.0.0/16"
      "24.128.232.109" # whitelist a specific IP
      #"nixos.wiki" # resolve the IP via DNS
    ];
    bantime = "24h"; # Ban IPs for one day on the first ban
    bantime-increment = {
      enable = true; # Enable increment of bantime after each violation
      formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
      #multipliers = "1 2 4 8 16 32 64";
      maxtime = "168h"; # Do not ban for more than 1 week
      overalljails = true; # Calculate the bantime based on all the violations
    };
    #jails = {
      #apache-nohome-iptables.settings = {
        # Block an IP address if it accesses a non-existent
        # home directory more than 5 times in 10 minutes,
        # since that indicates that it's scanning.
        #filter = "apache-nohome";
        #action = ''iptables-multiport[name=HTTP, port="http,https"]'';
        #logpath = "/var/log/httpd/error_log*";
        #backend = "auto";
        #findtime = 600;
        #bantime  = 600;
        #maxretry = 4;
      #};
    #};
  };

  services.udisks2.enable = true;#DBus service that allows applications to query and manipulate storage devices.

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
