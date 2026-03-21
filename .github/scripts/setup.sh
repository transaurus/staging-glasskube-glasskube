#!/bin/bash
# Generated setup script for: https://github.com/glasskube/glasskube.dev
# Note: The Docusaurus documentation site for glasskube is at glasskube/glasskube.dev
# Tested with successful i18n generation
# Requires Node.js >=24, pnpm 9

set -e

echo "Setting up glasskube.dev Docusaurus site for i18n generation..."

# Configuration
REPO_URL="https://github.com/glasskube/glasskube.dev.git"
BRANCH="main"

# Clean up if exists
if [ -d "source-repo" ]; then
  echo "Cleaning up existing directory..."
  rm -rf "source-repo"
fi

# Ensure Node 24 via nvm
if command -v nvm &>/dev/null || [ -s "$HOME/.nvm/nvm.sh" ]; then
  source "$HOME/.nvm/nvm.sh" 2>/dev/null || true
  CURRENT_NODE=$(node --version 2>/dev/null | sed 's/v//' | cut -d. -f1 || echo "0")
  if [ "$CURRENT_NODE" -lt 24 ]; then
    echo "Installing Node 24 via nvm..."
    nvm install 24
    nvm use 24
  fi
else
  CURRENT_NODE=$(node --version 2>/dev/null | sed 's/v//' | cut -d. -f1 || echo "0")
  if [ "$CURRENT_NODE" -lt 24 ]; then
    echo "Node 24+ required (found v$CURRENT_NODE). Installing via nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
    source "$HOME/.nvm/nvm.sh"
    nvm install 24
    nvm use 24
  fi
fi

echo "Node version: $(node --version)"
echo "npm version: $(npm --version)"

# Install pnpm if not available
if ! command -v pnpm &>/dev/null; then
  echo "Installing pnpm..."
  npm install -g pnpm@9
fi

echo "pnpm version: $(pnpm --version)"

# Clone repository
echo "Cloning repository from $REPO_URL..."
git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "source-repo"

# Navigate to Docusaurus directory (config is at root, no website/ subdir)
cd "source-repo"

# Install dependencies
echo "Installing dependencies with pnpm..."
pnpm install --frozen-lockfile

# Generate i18n files
echo "Generating i18n translation files..."
pnpm docusaurus write-translations

# Verify i18n files were created
if [ -d "i18n/en" ]; then
  echo "SUCCESS: i18n files successfully generated!"
  echo "Generated files in:"
  ls -la i18n/en/
else
  echo "FAILED: Failed to generate i18n files"
  exit 1
fi

echo "Setup complete! i18n files are ready."
