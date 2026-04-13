#!/bin/bash
set -e

REPO="Semporchothi-s/Project-Kee"
BASE_URL="https://github.com/$REPO/releases"

# Allow version override via env var, otherwise fetch latest from GitHub API
if [ -z "$KEE_VERSION" ]; then
  VERSION=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" \
    | grep '"tag_name"' \
    | sed 's/.*"tag_name": *"v\([^"]*\)".*/\1/')
fi
VERSION="${KEE_VERSION:-$VERSION}"

if [ -z "$VERSION" ]; then
  echo "Error: could not determine the latest kee version."
  echo "Set KEE_VERSION manually: KEE_VERSION=1.5.0 curl -fsSL ... | bash"
  exit 1
fi

echo "Installing kee v$VERSION..."

OS=$(uname -s)
ARCH=$(uname -m)

case "$OS" in
  Linux*)
    FILE="kee-linux-v$VERSION"
    ;;
  Darwin*)
    if [ "$ARCH" = "arm64" ]; then
      FILE="kee-mac-m-series-v$VERSION"
    else
      FILE="kee-mac-intel-v$VERSION"
    fi
    ;;
  MINGW*|MSYS*|CYGWIN*)
    echo "Windows detected. Run this in PowerShell instead:"
    echo ""
    echo "  irm https://raw.githubusercontent.com/$REPO/main/install.ps1 | iex"
    exit 0
    ;;
  *)
    echo "Unsupported OS: $OS"
    echo "Please build from source: https://github.com/$REPO#installation"
    exit 1
    ;;
esac

DOWNLOAD_URL="$BASE_URL/download/v$VERSION/$FILE"
echo "Downloading from: $DOWNLOAD_URL"

TMP=$(mktemp)
curl -fsSL "$DOWNLOAD_URL" -o "$TMP"
chmod +x "$TMP"
"$TMP" self-install
rm -f "$TMP"

echo ""
echo "kee v$VERSION installed successfully!"
echo "Restart your terminal, then run: kee --version"
