#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat >&2 <<'EOF'
usage: gateway-wrapper.sh --openclaw-bin <path> --port <port> [--path-entry <path>] [--secret-env <ENV_VAR=/path/to/secret>] [-- <extra args>]
EOF
  exit 64
}

OPENCLAW_BIN=""
PORT=""
declare -a PATH_ENTRIES=()
declare -a SECRET_SPECS=()

while (($# > 0)); do
  case "$1" in
    --openclaw-bin)
      [[ $# -ge 2 ]] || usage
      OPENCLAW_BIN="$2"
      shift 2
      ;;
    --port)
      [[ $# -ge 2 ]] || usage
      PORT="$2"
      shift 2
      ;;
    --path-entry)
      [[ $# -ge 2 ]] || usage
      PATH_ENTRIES+=("$2")
      shift 2
      ;;
    --secret-env)
      [[ $# -ge 2 ]] || usage
      SECRET_SPECS+=("$2")
      shift 2
      ;;
    --)
      shift
      break
      ;;
    *)
      usage
      ;;
  esac
done

[[ -n "$OPENCLAW_BIN" ]] || usage
[[ -n "$PORT" ]] || usage

for path_entry in "${PATH_ENTRIES[@]}"; do
  if [[ -n "$path_entry" ]]; then
    PATH="${path_entry}:${PATH}"
  fi
done
export PATH

for spec in "${SECRET_SPECS[@]}"; do
  env_var="${spec%%=*}"
  secret_file="${spec#*=}"
  if [[ -z "$env_var" ]] || [[ -z "$secret_file" ]] || [[ "$env_var" == "$secret_file" ]]; then
    echo "invalid --secret-env spec: $spec" >&2
    exit 64
  fi

  if [[ -r "$secret_file" ]]; then
    value="$(cat "$secret_file")"
    prefix="${env_var}="
    if [[ "$value" == "${prefix}"* ]]; then
      value="${value#"$prefix"}"
    fi
    export "${env_var}=${value}"
  fi
done

exec "$OPENCLAW_BIN" gateway --port "$PORT" "$@"
