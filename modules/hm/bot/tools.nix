{
  config,
  pkgs,
  ...
}: {
  home = {
    packages = with pkgs; [
      bashInteractive
      coreutils
      curl
      fd
      file
      findutils
      fzf
      gawk
      gcc
      gitui
      gnugrep
      gnumake
      gnused
      gnutar
      gzip
      jq
      less
      nodePackages_latest.nodejs
      go_1_25
      gopls
      gofumpt
      gotools
      golangci-lint
      golines
      gosec
      delve
      opencode
      pkg-config
      pnpm
      procps
      python3
      ripgrep
      rsync
      tmux
      unzip
      uv
      wget
      which
      xz
      yazi
      yq-go
      zip
      zx
    ];

    sessionVariables = {
      SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
    };

    sessionPath = [
      "/etc/profiles/per-user/${config.home.username}/bin"
      "/run/current-system/sw/bin"
      "/bin"
    ];
  };
}
