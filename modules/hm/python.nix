{pkgs, ...}: let
  packages = ps:
    with ps; [
      # mlxtend
      # We need to disable this for now because of this: https://github.com/NixOS/nixpkgs/issues/262000
      # ipykernel
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
    (python310.withPackages packages)
    cudaPackages.cudatoolkit
    cudaPackages.cudnn
    glibc
    poetry
    poetryPlugins.poetry-audit-plugin
    poetryPlugins.poetry-plugin-up
  ];
}
