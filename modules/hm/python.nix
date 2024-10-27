{pkgs, ...}: let
  packages = ps:
    with ps; [
      ipykernel
      matplotlib
      numpy
      pandas
      pip
      poetry-core
      poetry-dynamic-versioning
      poetry-semver
      scikit-learn
      # https://github.com/NixOS/nixpkgs/issues/350117
      torch-bin
      torchvision-bin
      torchmetrics
      tqdm
    ];
in {
  home.packages = with pkgs; [
    (python312.withPackages packages)
    cudaPackages.cudatoolkit
    glibc
    poetry
    poetryPlugins.poetry-audit-plugin
    poetryPlugins.poetry-plugin-up
  ];
}
