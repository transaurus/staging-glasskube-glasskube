#!/usr/bin/env bash
set -euo pipefail

# Rebuild script for glasskube/glasskube.dev
# Runs on existing source tree (no clone). Installs deps, runs pre-build steps, builds.

# --- Node version (requires Node 24, engines: >=24.0) ---
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    # shellcheck disable=SC1091
    . "$NVM_DIR/nvm.sh"
    if ! nvm ls 24 2>/dev/null | grep -q "v24\." ; then
        echo "[INFO] Installing Node 24..."
        nvm install 24
    fi
    nvm use 24
else
    echo "[ERROR] nvm not found. Node 24 is required (engines: >=24.0)."
    exit 1
fi

# --- pnpm (version 10, as used in CI) ---
if ! command -v pnpm &>/dev/null || ! pnpm --version | grep -q "^10"; then
    echo "[INFO] Installing pnpm 10..."
    npm install -g pnpm@10
fi

# --- Dependencies ---
pnpm install --frozen-lockfile

# --- Build ---
pnpm run build

echo "[DONE] Build complete."
