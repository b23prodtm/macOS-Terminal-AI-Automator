#!/usr/bin/env bash
#
# build_pkg.sh - Build a macOS .pkg installer for macOS Terminal AI Automator.
#
# Must be run on macOS (uses the built-in `pkgbuild` tool).
#
# Usage:
#   ./pkg/build_pkg.sh [version]
#
# Produces:
#   dist/macos-terminal-ai-automator-<version>.pkg
#
set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "❌ build_pkg.sh must be run on macOS (requires pkgbuild)." >&2
    exit 1
fi

if ! command -v pkgbuild >/dev/null 2>&1; then
    echo "❌ pkgbuild not found. It ships with Xcode Command Line Tools." >&2
    exit 1
fi

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VERSION="${1:-$(cat "$REPO_ROOT/VERSION" 2>/dev/null || echo "1.0.0")}"
IDENTIFIER="com.b23prodtm.macos-terminal-ai-automator"

PKG_DIR="$REPO_ROOT/pkg"
BUILD_DIR="$(mktemp -d)"
PAYLOAD_DIR="$BUILD_DIR/payload"
DIST_DIR="$REPO_ROOT/dist"

cleanup() { rm -rf "$BUILD_DIR"; }
trap cleanup EXIT

echo "=== Building macos-terminal-ai-automator.pkg (v$VERSION) ==="

# --- Assemble payload --------------------------------------------------------
LIB_DEST="$PAYLOAD_DIR/usr/local/lib/macos-terminal-ai-automator"
BIN_DEST="$PAYLOAD_DIR/usr/local/bin"

mkdir -p "$LIB_DEST" "$BIN_DEST"

for f in "$REPO_ROOT/scripts/ai.py" "$REPO_ROOT/scripts/ag.py" "$REPO_ROOT/requirements.txt" \
         "$PKG_DIR/bin/ai" "$PKG_DIR/bin/ag"; do
    if [[ ! -f "$f" ]]; then
        echo "❌ Required file not found: $f" >&2
        exit 1
    fi
done

cp "$REPO_ROOT/scripts/ai.py" "$LIB_DEST/ai.py"
cp "$REPO_ROOT/scripts/ag.py" "$LIB_DEST/ag.py"
cp "$REPO_ROOT/requirements.txt" "$LIB_DEST/requirements.txt"
cp "$PKG_DIR/bin/ai" "$BIN_DEST/ai"
cp "$PKG_DIR/bin/ag" "$BIN_DEST/ag"

shopt -s nullglob
chmod +x "$LIB_DEST"/*.py "$BIN_DEST/ai" "$BIN_DEST/ag"
shopt -u nullglob

mkdir -p "$DIST_DIR"

pkgbuild \
    --root "$PAYLOAD_DIR" \
    --identifier "$IDENTIFIER" \
    --version "$VERSION" \
    --install-location "/" \
    --scripts "$PKG_DIR/scripts" \
    "$DIST_DIR/macos-terminal-ai-automator-$VERSION.pkg"

echo "✅ Package created: dist/macos-terminal-ai-automator-$VERSION.pkg"
