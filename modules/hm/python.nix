{pkgs, ...}: {
  home.packages = with pkgs; [
    python310Full
    python310Packages.huggingface-hub
    python310Packages.langchain
    python310Packages.matplotlib
    python310Packages.numpy
    python310Packages.pandas
    python310Packages.scikit-learn
    python310Packages.scipy
    python310Packages.torch
    python310Packages.torchvision
  ];
}
