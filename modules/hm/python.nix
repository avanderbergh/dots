{
  flake.modules.homeManager."profile-python" = {pkgs, ...}: let
    packages = ps:
      with ps; [
        pip
      ];
  in {
    home.packages = with pkgs; [
      (python312.withPackages packages)
      glibc
      uv
      cudaPackages.cudatoolkit
    ];
  };
}
