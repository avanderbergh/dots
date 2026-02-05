{pkgs, ...}: {
  home.packages = with pkgs; [
    (python312.withPackages (ps: with ps; [ pip ]))
    uv
  ];
}
