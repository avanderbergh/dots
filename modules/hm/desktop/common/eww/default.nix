{
  pkgs,
  colors,
  hostConfig,
  ...
}: let
  attrToLine = attr: "\$" + attr + ": " + builtins.getAttr attr colors + ";";
in {
  home.packages = [pkgs.eww];
  xdg.configFile = {
    "eww/eww.yuck".source = pkgs.writeText "eww.yuck" (
      builtins.replaceStrings
      ["{{TOP_DISTANCE}}"]
      [hostConfig.top-distance]
      (builtins.readFile ./config/eww.yuck)
    );
    "eww/eww.scss".source = ./config/eww.scss;
    "eww/_colors.scss".text = builtins.concatStringsSep "\n" (
      map attrToLine (builtins.attrNames colors)
    );
  };
}
