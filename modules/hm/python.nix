{pkgs, ...}: let
  packages = ps:
    with ps; [
      pip
    ];

  cudaPackages = with pkgs.cudaPackages; [
    cuda_cudart
    cuda_nvcc
    libcublas
  ];
in {
  home.packages = with pkgs;
    [
      (python312.withPackages packages)
      glibc
      uv
    ]
    ++ cudaPackages;
}
