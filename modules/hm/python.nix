{
  flake.modules.homeManager."profile-python" = {pkgs, ...}: let
    packages = ps:
      with ps; [
        pip
      ];
  in {
    # Keep global Python tooling minimal; provide CUDA toolkits per project
    # via direnv / devenv instead of pulling cudatoolkit into every home closure.
    home.packages = with pkgs; [
      (python312.withPackages packages)
      uv
    ];
  };
}
