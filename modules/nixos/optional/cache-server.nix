{
  pkgs,
  lib,
  config,
  ...
}: let
  repoDir = "/home/avanderbergh/repos/github.com/avanderbergh/dots";

  hosts = ["zoidberg" "hermes" "farnsworth"];

  username = "avanderbergh";
  key_mode = "0400";

  updateBuildScript = pkgs.writeShellScript "update-and-build.sh" ''
    #!/usr/bin/env bash
    set -euo pipefail

    REPO_DIR="${repoDir}"
    BRANCH_NAME="flake-update-$(date +%Y%m%d%H%M%S)"
    HOSTS=(
      ${lib.concatStringsSep "\n  " (map (host: "\"${host}\"") hosts)}
    )

    GH_TOKEN="$(cat ${config.sops.secrets.morbo_git_token.path})"

    # Read the morbo-bot SSH key content
    MORBO_SSH_KEY_CONTENT="$(cat ${config.sops.secrets.morbo_ssh_key.path})"

    # Set Git configuration for morbo-bot
    export GIT_AUTHOR_NAME="Morbo"
    export GIT_AUTHOR_EMAIL="avanderbergh+morbo@gmail.com"
    export GIT_COMMITTER_NAME="Morbo"
    export GIT_COMMITTER_EMAIL="avanderbergh+morbo@gmail.com"

    # Export GH_TOKEN for GitHub CLI authentication
    export GH_TOKEN="$GH_TOKEN"

    # Create a temporary file for the SSH key
    TEMP_SSH_KEY="$(mktemp)"
    chmod 600 "$TEMP_SSH_KEY"
    echo "$MORBO_SSH_KEY_CONTENT" > "$TEMP_SSH_KEY"

    # Create a temporary SSH config file
    TEMP_SSH_CONFIG="$(mktemp)"
    chmod 600 "$TEMP_SSH_CONFIG"

    cat > "$TEMP_SSH_CONFIG" << EOF
    Host github.com
      HostName github.com
      IdentityFile $TEMP_SSH_KEY
      IdentitiesOnly yes
      StrictHostKeyChecking accept-new
    EOF

    # Use the custom SSH config for git commands
    export GIT_SSH_COMMAND="ssh -F $TEMP_SSH_CONFIG"

    cd "$REPO_DIR"

    # Ensure the working directory is clean
    if [[ -n $(git status --porcelain) ]]; then
      echo "Working directory is not clean. Please commit or stash changes."
      exit 1
    fi

    # Update flake inputs
    echo "Updating flake inputs..."
    nix flake update

    # Check if flake.lock changed
    if git diff --quiet flake.lock; then
      echo "No updates found in flake inputs."
      exit 0
    fi

    # Create a new branch
    echo "Creating new branch: $BRANCH_NAME"
    git checkout -b "$BRANCH_NAME"

    # Commit the updated flake.lock
    echo "Committing changes..."
    git add flake.lock
    git commit -m "Update flake inputs"

    # Push the branch to remote
    echo "Pushing branch to origin..."
    git push -u origin "$BRANCH_NAME"

    # Build configurations for all hosts to populate the cache
    echo "Building configurations to populate cache..."

    build_failed=false
    build_failures=""

    for HOST in "''${HOSTS[@]}"; do
      echo "Building configuration for $HOST..."
      BUILD_LOG="$(mktemp)"
      if nix build ".#nixosConfigurations.$HOST.config.system.build.toplevel" --no-link > "$BUILD_LOG" 2>&1; then
        echo "Build for $HOST succeeded."
      else
        echo "Build for $HOST failed."
        build_failed=true
        build_log=$(tail -n 50 "$BUILD_LOG")
        build_failures="$build_failures\n\n### Build failed for $HOST:\n\n```\n$build_log\n```"
      fi
      # Remove the build log file
      rm -f "$BUILD_LOG"
    done

    # Prepare PR title and body based on build results
    if [ "$build_failed" = true ]; then
      pr_title="Update flake inputs"
      pr_body="Automated update of flake inputs.\n\nSome builds failed:\n$build_failures"
      pr_flags="--draft"
    else
      pr_title="Update flake inputs"
      pr_body="Automated update of flake inputs.\n\nAll builds succeeded."
      pr_flags=""
    fi

    # Create a pull request using GitHub CLI
    echo "Creating pull request..."
    gh pr create $pr_flags --title "$pr_title" --body "$pr_body"

    echo "All done."

    # Clean up temporary SSH key and config
    rm -f "$TEMP_SSH_KEY" "$TEMP_SSH_CONFIG"
  '';
in {
  services.nix-serve = {
    enable = true;
    openFirewall = true;
    secretKeyFile = "/var/cache-priv-key.pem";
  };

  environment.persistence."/persist".files = ["/var/cache-priv-key.pem"];

  environment.systemPackages = with pkgs; [
    gh
  ];

  sops.secrets = {
    morbo_git_token = {
      owner = username;
      group = username;
      mode = key_mode;
    };
    morbo_ssh_key = {
      owner = username;
      group = username;
      mode = key_mode;
    };
  };

  systemd.services.update-and-build = {
    description = "Update flake inputs and build NixOS configurations";
    after = ["network-online.target"];
    wants = ["network-online.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${updateBuildScript}";
      WorkingDirectory = "${repoDir}";
      User = "avanderbergh";
      Environment = [
        "HOME=/home/avanderbergh"
      ];
    };
  };

  # systemd.timers.update-and-build = {
  #   description = "Run update-and-build.service daily";
  #   wantedBy = ["timers.target"];
  #   timerConfig = {
  #     OnCalendar = "02:00";
  #     Persistent = true;
  #   };
  # };
}
