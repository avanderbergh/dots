{pkgs, ...}: let
  packages = ps:
    with ps; [
      # mlxtend
      ipykernel
      matplotlib
      numpy
      pandas
      pip
      scikit-learn
      torch-bin
      torchmetrics
      torchvision-bin
      tqdm
    ];
in {
  home.packages = with pkgs; [
    (python310.withPackages packages)
  ];
}
