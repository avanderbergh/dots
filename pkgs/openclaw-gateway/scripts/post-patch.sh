#!/usr/bin/env bash
set -e

if [ -f package.json ]; then
  tmp_package_json="$(mktemp)"
  jq 'del(.packageManager)' package.json > "$tmp_package_json"
  mv "$tmp_package_json" package.json
fi

if [ -f src/logging/logger.ts ]; then
  if ! grep -q "OPENCLAW_LOG_DIR" src/logging/logger.ts; then
    sed -i 's/export const DEFAULT_LOG_DIR = "\/tmp\/openclaw";/export const DEFAULT_LOG_DIR = process.env.OPENCLAW_LOG_DIR ?? "\/tmp\/openclaw";/' src/logging/logger.ts
  fi
fi

if [ -f src/agents/shell-utils.ts ]; then
  if ! grep -q "envShell" src/agents/shell-utils.ts; then
    awk '
      /import { spawn } from "node:child_process";/ {
        print;
        print "import { existsSync } from \"node:fs\";";
        next;
      }
      /const shell = process.env.SHELL/ {
        print "  const envShell = process.env.SHELL?.trim();";
        print "  const shell =";
        print "    envShell && envShell.startsWith(\"/\") && !existsSync(envShell)";
        print "      ? \"sh\"";
        print "      : envShell || \"sh\";";
        next;
      }
      { print }
    ' src/agents/shell-utils.ts > src/agents/shell-utils.ts.next
    mv src/agents/shell-utils.ts.next src/agents/shell-utils.ts
  fi
fi
