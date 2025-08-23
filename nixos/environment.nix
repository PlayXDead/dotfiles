{ config, pkgs, inputs, ... }:

{
  security.polkit.enable = true;

  services.gnome.gnome-keyring.enable = true;

  #For i3
  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw

  # Enable Desktop Environment
  services = {
    displayManager.sddm.enable = true;
    xserver = {
      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        extraPackages = with pkgs; [
          i3status
	  i3lock
	  i3blocks
	  autotiling
	  polybar
	  dunst
	  picom
	  tint2
        ];
      };  
      windowManager.awesome = {
        enable = true;
        luaModules = with pkgs.luaPackages; [
          luarocks # is the package manager for Lua modules
          luadbi-mysql # Database abstraction layer
          awesome-wm-widgets # Community collection of widgets
        ];

      };
    };
  };  

  #default session
 # services.displayManager.defaultSession = "hyprland";

  #Hyprland
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    #package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  };
  services.hypridle.enable = true;


  # Optional, hint electron apps to use wayland:
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  #apply default themes to wayland (KDE)
  #programs.dconf.enable = true;
  #qt.platformTheme = "gnome"; qt.style = "breeze";
}

