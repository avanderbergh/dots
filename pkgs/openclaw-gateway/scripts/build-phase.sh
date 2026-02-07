#!/usr/bin/env bash
set -e

runHook preBuild

store_path_file=".pnpm-store-path"
store_path="$(mktemp -d)"
printf "%s" "$store_path" > "$store_path_file"

fetcherVersion="$(cat "$pnpmDeps/.fetcher-version" 2>/dev/null || echo 1)"
if [ "$fetcherVersion" -ge 3 ]; then
  tar --zstd -xf "$pnpmDeps/pnpm-store.tar.zst" -C "$store_path"
else
  cp -Tr "$pnpmDeps" "$store_path"
fi
chmod -R +w "$store_path"

find "$store_path" -name "integrity-not-built.json" \
  | while IFS= read -r file; do
      if jq -e '.requiresBuild == true' "$file" >/dev/null; then
        continue
      fi
      cp "$file" "${file%integrity-not-built.json}integrity.json"
    done

export REAL_NODE_GYP="$(command -v node-gyp)"
wrapper_dir="$(mktemp -d)"
install -Dm755 "$NODE_GYP_WRAPPER_SH" "$wrapper_dir/node-gyp"
export PATH="$wrapper_dir:$PATH"

export PNPM_STORE_DIR="$store_path"
export PNPM_STORE_PATH="$store_path"
export NPM_CONFIG_STORE_DIR="$store_path"
export NPM_CONFIG_STORE_PATH="$store_path"
export HOME="$(mktemp -d)"

pnpm install --offline --frozen-lockfile --ignore-scripts --store-dir "$store_path"
chmod -R u+w node_modules
rm -rf node_modules/.pnpm/sharp@*/node_modules/sharp/src/build
NODE_LLAMA_CPP_SKIP_DOWNLOAD=1 pnpm rebuild
patchShebangs node_modules/.bin
pnpm build
pnpm ui:build
CI=true pnpm prune --prod
rm -rf node_modules/.pnpm/node_modules

runHook postBuild
