# ~/.config/home-manager/modules/steamvr.nix

{ config, lib, pkgs, ... }:

let
  # Define a reusable string for the configuration file content
  steamvrSettings = {
    steamvr = {
      enableLinuxVulkanAsync = config.programs.steamvr.enableLinuxVulkanAsync;
    };
    version = 1;
  };

  # Convert the Nix attribute set to a JSON string
  steamvrSettingsJson = builtins.toJSON steamvrSettings;

in
{
  options.programs.steamvr = {
    # 1. Add an explicit 'enable' option
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable declarative management of SteamVR settings.";
    };

    enableLinuxVulkanAsync = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Vulkan asynchronous reprojection for Linux SteamVR.";
    };
  };

  # 2. Use the new, reliable 'enable' option in mkIf
  config = lib.mkIf config.programs.steamvr.enable (
    let
      steamConfigDir = "${config.xdg.dataHome}/Steam/config";
    in
    {
      xdg.configFile."steam/config/steamvr.vrsettings" = {
        enable = true;
        text = steamvrSettingsJson;
      };

      xdg.configFile."openvr/openvrpaths.vrpath".text = ''
        {
          "config" : [ "${steamConfigDir}" ],
          "external_drivers" : null,
          "jsonid" : "vrpathreg",
          "log" : [ "${config.xdg.dataHome}/Steam/logs" ],
          "runtime" : [ "${pkgs.steam-run}/share/openvr/runtime" ],
          "version" : 1
        }
      '';
    }
  );
}

