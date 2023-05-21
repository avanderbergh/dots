{
  pkgs,
  colors,
  ...
}: let
  attrToLine = attr: "\$" + attr + ": " + builtins.getAttr attr colors + ";";
in {
  home.packages = [pkgs.eww];
  xdg.configFile = {
    "eww/eww.yuck".source = ./config/eww.yuck;
    "eww/eww.scss".source = ./config/eww.scss;
    "eww/_colors.scss".text = builtins.concatStringsSep "\n" (
      map attrToLine (builtins.attrNames colors)
    );
  };
}
