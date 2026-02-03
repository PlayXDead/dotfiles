
#======================================================================================
#Monado
#=======================================================================================
{ config, pkgs, ... }:
{
  #For Monado:
  xdg.configFile."openxr/1/active_runtime.json".source = "${pkgs.monado}/share/openxr/1/openxr_monado.json";

  xdg.configFile."openvr/openvrpaths.vrpath".text = let
    steam = "${config.xdg.dataHome}/Steam";
  in builtins.toJSON {
    version = 1;
    jsonid = "vrpathreg";

    external_drivers = null;
    config = [ "${steam}/config" ];

    log = [ "${steam}/logs" ];

    "runtime" = [
      "${pkgs.opencomposite}/lib/opencomposite"
    ];
  };
}
