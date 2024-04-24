{pkgs, ...}: let
  packages = ps:
    with ps; [
      # mlxtend
      ipykernel
      matplotlib
      numpy
      pandas
      pip
      poetry-core
      poetry-dynamic-versioning
      poetry-semver
      scikit-learn
      torch-bin
      torchmetrics
      torchvision-bin
      tqdm
    ];
in {
  home.packages = with pkgs; [
    (python3.withPackages packages)
    # https://github.com/NixOS/nixpkgs/issues/305583
    # cudaPackages.cudatoolkit
    cudaPackages.cudnn
    glibc
    poetry
    # Build Failing
    # poetryPlugins.poetry-audit-plugin
    poetryPlugins.poetry-plugin-up
  ];
}
