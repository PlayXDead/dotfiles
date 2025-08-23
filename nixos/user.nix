{ config, pkgs, inputs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tim = {
    initialPassword = "password";
    isNormalUser = true;
    extraGroups = [ "wheel" "wireshark" "docker" "vboxusers" "libvirtd" "games" "gamemode" "video" "jackaudio" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
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
      nodePackages_latest.nodejs
      looking-glass-client
      qemu
      libguestfs #tool to modify vm
      guestfs-tools #tool to modify vm
      OVMFFull#enable secure boot for QEMU
      dnsmasq
      cpuset
      rofi
      prismlauncher
      pulseaudio
      gccgo# C compiler
      fzf #Fuzzy finder for term
      tlrc
      neofetch
      cmatrix
      findutils
      discord
      ripgrep #used with Telescope(neovim)
      gtk-layer-shell
      nvtopPackages.full
      mediawriter
      nmap
      #vagrant
      gh #git hub cli
      swaynotificationcenter
      #rpcs3 #Ps3 emulator
      pcsx2 #PS2 emulator
      obsidian #Powerful Notes Application
      libsForQt5.kdenlive #Video Editor
      #packer #packaging tool. Used for metasploitable build
      keepass
      hyprlock#screen locking utility
      easyeffects
      openvpn
      lutris
      wineWowPackages.stable
      winetricks
      tor-browser
      burpsuite
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
      piper#configure keyboard buttons like logitech ghub
      libratbag#backend for piper
      zoom-us
      nautilus#Gnome file explorer
      lxappearance # configure the appearance of GTK themed apps
      heroic
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
      tldr
      flowtime # work efficiently
      mousam # weather app
      teams-for-linux# teams app for linux
      teamspeak_client
      stacer # system monitor and cleaner
      fwknop #Single Packet Authorization (and Port Knocking) server/client
      wireguard-tools #tools for wireguard vpn
      tigervnc
      onedrive
      errands # to do list 
      bottles
      inputs.zen-browser.packages.${pkgs.system}.default
      pdfarranger
      googleearth-pro
      qgis-ltr
      bitwig-studio
      devbox
      vrc-get
      #unityhub
      wlx-overlay-s
      blender
      bs-manager #beatsaber manager
      hyprshot
      xmind
      android-studio
    ];
  };
}
