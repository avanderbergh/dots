#!/usr/bin/env bash
set -u
set -o pipefail

MODE="fix"
SKIP_PARSE=0
SKIP_LINT=0
LINT_ALL=0
SKIP_FLAKE_CHECK=0
ALLOW_UNTRACKED=0
AUTO_GIT_ADD=1
EXTRA_FLAKE_ARGS=()

if [[ -t 1 ]]; then
  C_RED=$'\033[31m'
  C_GREEN=$'\033[32m'
  C_YELLOW=$'\033[33m'
  C_CYAN=$'\033[36m'
  C_RESET=$'\033[0m'
else
  C_RED=""
  C_GREEN=""
  C_YELLOW=""
  C_CYAN=""
  C_RESET=""
fi

log_section() {
  printf "\n%s== %s ==%s\n" "${C_CYAN}" "$1" "${C_RESET}"
}

log_ok() {
  printf "%s[ok]%s %s\n" "${C_GREEN}" "${C_RESET}" "$1"
}

log_warn() {
  printf "%s[warn]%s %s\n" "${C_YELLOW}" "${C_RESET}" "$1"
}

log_fail() {
  printf "%s[fail]%s %s\n" "${C_RED}" "${C_RESET}" "$1"
}

usage() {
  cat <<'EOF'
Usage: nix-dev-check.sh [options] [-- <extra nix flake check args>]

Options:
  --check             Run alejandra in check mode (do not modify files).
  --skip-parse        Skip syntax checks for changed .nix files.
  --skip-lint         Skip statix lint checks.
  --lint-all          Run statix on the whole repository.
  --skip-flake-check  Skip nix flake check.
  --allow-untracked   Run flake check even with untracked files.
  --no-auto-add       Do not run git add -A before flake check.
  --help              Show this help text.
EOF
}

while (($# > 0)); do
  case "$1" in
    --check)
      MODE="check"
      shift
      ;;
    --skip-parse)
      SKIP_PARSE=1
      shift
      ;;
    --skip-lint)
      SKIP_LINT=1
      shift
      ;;
    --lint-all)
      LINT_ALL=1
      shift
      ;;
    --skip-flake-check)
      SKIP_FLAKE_CHECK=1
      shift
      ;;
    --allow-untracked)
      ALLOW_UNTRACKED=1
      shift
      ;;
    --no-auto-add)
      AUTO_GIT_ADD=0
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    --)
      shift
      EXTRA_FLAKE_ARGS=("$@")
      break
      ;;
    *)
      printf "Unknown argument: %s\n\n" "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

command -v git >/dev/null 2>&1 || {
  printf "git is required\n" >&2
  exit 1
}
command -v rg >/dev/null 2>&1 || {
  printf "rg is required\n" >&2
  exit 1
}
command -v alejandra >/dev/null 2>&1 || {
  printf "alejandra is required\n" >&2
  exit 1
}
command -v statix >/dev/null 2>&1 || {
  printf "statix is required\n" >&2
  exit 1
}
command -v nix >/dev/null 2>&1 || {
  printf "nix is required\n" >&2
  exit 1
}
command -v nix-instantiate >/dev/null 2>&1 || {
  printf "nix-instantiate is required\n" >&2
  exit 1
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../../../.." && pwd)"
if [[ ! -f "${REPO_ROOT}/flake.nix" ]]; then
  REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
fi

if [[ -z "${REPO_ROOT}" || ! -f "${REPO_ROOT}/flake.nix" ]]; then
  printf "Could not resolve repository root with flake.nix\n" >&2
  exit 1
fi

cd "${REPO_ROOT}"

HOSTNAME_SHORT="$(hostname --short 2>/dev/null || true)"
if [[ -z "${HOSTNAME_SHORT}" ]]; then
  HOSTNAME_SHORT="$(hostnamectl --static 2>/dev/null || true)"
fi

log_section "Environment"
printf "Repo root: %s\n" "${REPO_ROOT}"
printf "Host: %s\n" "${HOSTNAME_SHORT:-unknown}"
printf "Nix: %s\n" "$(nix --version)"
printf "Alejandra: %s\n" "$(alejandra --version)"
printf "Statix: %s\n" "$(statix --version)"

log_section "Host Hints"
if [[ -n "${HOSTNAME_SHORT}" && -f "hosts/${HOSTNAME_SHORT}/default.nix" ]]; then
  log_ok "Found hosts/${HOSTNAME_SHORT}/default.nix"
else
  log_warn "No hosts/<hostname>/default.nix match for '${HOSTNAME_SHORT:-unknown}'"
fi

if [[ -n "${HOSTNAME_SHORT}" ]] && rg -n "^[[:space:]]*${HOSTNAME_SHORT}[[:space:]]*=" flake.nix >/dev/null; then
  log_ok "Hostname appears in flake.nix outputs"
else
  log_warn "Hostname not detected in flake.nix output blocks"
fi

collect_changed_nix_files() {
  {
    git diff --name-only -- '*.nix'
    git diff --cached --name-only -- '*.nix'
    git ls-files --others --exclude-standard -- '*.nix'
  } | sort -u
}

collect_untracked_files() {
  git ls-files --others --exclude-standard
}

PARSE_STATUS=0
FORMAT_STATUS=0
LINT_STATUS=0
FLAKE_STATUS=0
FLAKE_BLOCKED_UNTRACKED=0

if ((SKIP_PARSE == 0)); then
  log_section "Syntax Parse"
  mapfile -t CHANGED_NIX < <(collect_changed_nix_files)
  if ((${#CHANGED_NIX[@]} == 0)); then
    log_warn "No changed .nix files detected. Skipping parse stage."
  else
    printf "Checking %d changed file(s).\n" "${#CHANGED_NIX[@]}"
    for file in "${CHANGED_NIX[@]}"; do
      [[ -f "${file}" ]] || continue
      if parse_error="$(nix-instantiate --parse "${file}" 2>&1 >/dev/null)"; then
        log_ok "${file}"
      else
        PARSE_STATUS=1
        log_fail "${file}"
        printf "%s\n" "${parse_error}" | sed 's/^/  | /'
      fi
    done
  fi
fi

log_section "Formatting"
if [[ "${MODE}" == "check" ]]; then
  if alejandra --check .; then
    log_ok "alejandra --check passed"
  else
    FORMAT_STATUS=1
    log_fail "alejandra --check failed"
  fi
else
  if alejandra .; then
    log_ok "alejandra formatting pass completed"
  else
    FORMAT_STATUS=1
    log_fail "alejandra formatting failed"
  fi
fi

mapfile -t DIRTY_NIX < <(git status --porcelain -- '*.nix' | sed -E 's/^...//' | sort -u)
if ((${#DIRTY_NIX[@]} > 0)); then
  printf "Nix files with local modifications:\n"
  printf "  - %s\n" "${DIRTY_NIX[@]}"
fi

if ((AUTO_GIT_ADD == 1)); then
  log_section "Stage Files"
  if git add -A; then
    log_ok "Staged repository changes with git add -A"
  else
    log_fail "git add -A failed"
    exit 1
  fi
fi

if ((SKIP_LINT == 0)); then
  log_section "Lint (statix)"
  if ((LINT_ALL == 1)); then
    if lint_output="$(statix check --format errfmt . 2>&1)"; then
      log_ok "statix check passed for repository"
    else
      LINT_STATUS=1
      log_fail "statix check reported findings"
      printf "%s\n" "${lint_output}" | sed 's/^/  | /'
    fi
  else
    mapfile -t LINT_TARGETS < <(collect_changed_nix_files)
    if ((${#LINT_TARGETS[@]} == 0)); then
      log_warn "No changed .nix files detected. Skipping lint stage."
    else
      printf "Linting %d changed file(s).\n" "${#LINT_TARGETS[@]}"
      for file in "${LINT_TARGETS[@]}"; do
        [[ -f "${file}" ]] || continue
        if lint_output="$(statix check --format errfmt "${file}" 2>&1)"; then
          log_ok "${file}"
        else
          LINT_STATUS=1
          log_fail "${file}"
          printf "%s\n" "${lint_output}" | sed 's/^/  | /'
        fi
      done
    fi
  fi
fi

if ((SKIP_FLAKE_CHECK == 0)); then
  if ((PARSE_STATUS != 0)); then
    log_warn "Skipping nix flake check because syntax parse failed."
    FLAKE_STATUS=1
  else
    mapfile -t UNTRACKED_FILES < <(collect_untracked_files)
    if ((${#UNTRACKED_FILES[@]} > 0)) && ((ALLOW_UNTRACKED == 0)); then
      log_section "Flake Check"
      log_warn "Blocked: untracked files detected."
      log_warn "Git flakes ignore untracked files, which often breaks evaluation when new files are referenced."
      printf "Untracked files:\n"
      printf "  - %s\n" "${UNTRACKED_FILES[@]}"
      printf "Action: git add the needed files, then rerun this script.\n"
      printf "Override: rerun with --allow-untracked to force flake check.\n"
      FLAKE_STATUS=1
      FLAKE_BLOCKED_UNTRACKED=1
    else
      log_section "Flake Check"
      FLAKE_CMD=(nix flake check --show-trace -L)
      if ((${#EXTRA_FLAKE_ARGS[@]} > 0)); then
        FLAKE_CMD+=("${EXTRA_FLAKE_ARGS[@]}")
      fi
      if "${FLAKE_CMD[@]}"; then
        log_ok "nix flake check passed"
      else
        FLAKE_STATUS=1
        log_fail "nix flake check failed"
      fi
    fi
  fi
fi

log_section "Summary"
printf "syntax-parse: %s\n" "$([[ ${PARSE_STATUS} -eq 0 ]] && printf "pass" || printf "fail")"
printf "formatting: %s\n" "$([[ ${FORMAT_STATUS} -eq 0 ]] && printf "pass" || printf "fail")"
if ((SKIP_LINT == 1)); then
  printf "lint-statix: skipped\n"
else
  printf "lint-statix: %s\n" "$([[ ${LINT_STATUS} -eq 0 ]] && printf "pass" || printf "fail")"
fi
if ((SKIP_FLAKE_CHECK == 1)); then
  printf "flake-check: skipped\n"
elif ((FLAKE_BLOCKED_UNTRACKED == 1)); then
  printf "flake-check: blocked-untracked\n"
else
  printf "flake-check: %s\n" "$([[ ${FLAKE_STATUS} -eq 0 ]] && printf "pass" || printf "fail")"
fi

if ((FORMAT_STATUS != 0)) && [[ "${MODE}" == "check" ]]; then
  printf "hint: run without --check to auto-format with alejandra.\n"
fi
if ((PARSE_STATUS != 0)); then
  printf "hint: fix parse errors first, then rerun full checks.\n"
fi
if ((LINT_STATUS != 0)); then
  printf "hint: review statix findings, then use 'statix fix <path>' where appropriate.\n"
fi
if ((FLAKE_BLOCKED_UNTRACKED == 1)); then
  printf "hint: add new files to git so flake evaluation can see them.\n"
fi
if ((FLAKE_STATUS != 0)) && ((SKIP_FLAKE_CHECK == 0)) && ((FLAKE_BLOCKED_UNTRACKED == 0)); then
  printf "hint: rerun with extra args, e.g. -- --keep-going.\n"
fi

if ((PARSE_STATUS != 0 || FORMAT_STATUS != 0 || LINT_STATUS != 0 || FLAKE_STATUS != 0)); then
  exit 1
fi

exit 0
