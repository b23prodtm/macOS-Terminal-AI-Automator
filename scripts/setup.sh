#!/usr/bin/env bash
#
# setup.sh - One-step setup for macOS Terminal AI Automator
#
# What it does:
#   1. Checks that Python 3 and a supported shell are available.
#   2. Installs the required Python dependencies (groq, rich).
#   3. Makes ai.py / ag.py executable.
#   4. Configures your shell (~/.zshrc or ~/.bash_profile) with `ai` and `ag`
#      aliases so you can run the tools from anywhere.
#   5. Optionally helps you set your GROQ_API_KEY.
#
# Usage:
#   ./scripts/setup.sh
#
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCRIPTS_DIR="$REPO_ROOT/scripts"

info()  { printf "ℹ️  %s\n" "$1"; }
ok()    { printf "✅ %s\n" "$1"; }
warn()  { printf "⚠️  %s\n" "$1"; }
fail()  { printf "❌ %s\n" "$1"; exit 1; }

echo "=== macOS Terminal AI Automator — Setup ==="

# --- 1. Check prerequisites -------------------------------------------------
if [[ "$(uname -s)" != "Darwin" ]]; then
    warn "This project is designed for macOS. Continuing anyway."
fi

if ! command -v python3 >/dev/null 2>&1; then
    fail "Python 3 is required but was not found. Install it with 'brew install python' and re-run this script."
fi
ok "Found $(python3 --version)"

if ! command -v pip3 >/dev/null 2>&1; then
    fail "pip3 is required but was not found. It normally ships with Python 3."
fi
ok "Found pip3"

CURRENT_SHELL="$(basename "${SHELL:-sh}")"
if [[ "$CURRENT_SHELL" != "zsh" && "$CURRENT_SHELL" != "bash" ]]; then
    warn "Unsupported shell detected ($CURRENT_SHELL). Alias setup will be skipped."
fi
ok "Detected shell: $CURRENT_SHELL"

# --- 2. Install Python dependencies -----------------------------------------
info "Installing Python dependencies..."
if [[ -f "$REPO_ROOT/requirements.txt" ]]; then
    python3 -m pip install --user -r "$REPO_ROOT/requirements.txt"
else
    python3 -m pip install --user groq rich
fi
ok "Python dependencies installed"

# --- 3. Make scripts executable ----------------------------------------------
chmod +x "$SCRIPTS_DIR"/*.py
ok "Made scripts executable"

# --- 4. Configure shell aliases ----------------------------------------------
case "$CURRENT_SHELL" in
    zsh)  RC_FILE="$HOME/.zshrc" ;;
    bash) RC_FILE="$HOME/.bash_profile" ;;
    *)    RC_FILE="" ;;
esac

if [[ -n "$RC_FILE" ]]; then
    touch "$RC_FILE"
    if ! grep -q "macos-terminal-ai-automator aliases" "$RC_FILE" 2>/dev/null; then
        {
            echo ""
            echo "# macos-terminal-ai-automator aliases"
            echo "alias ai=\"python3 $SCRIPTS_DIR/ai.py\""
            echo "alias ag=\"python3 $SCRIPTS_DIR/ag.py\""
        } >> "$RC_FILE"
        ok "Added 'ai' and 'ag' aliases to $RC_FILE"
    else
        info "Aliases already present in $RC_FILE"
    fi
    info "Run 'source $RC_FILE' or restart your terminal to start using 'ai' and 'ag'."
fi

# --- 5. Optional GROQ_API_KEY setup ------------------------------------------
if [[ -z "${GROQ_API_KEY:-}" ]]; then
    warn "GROQ_API_KEY is not set in your current environment."
    if [[ -n "$RC_FILE" ]] && [[ -t 0 ]] && ! grep -q "GROQ_API_KEY" "$RC_FILE" 2>/dev/null; then
        read -r -p "Enter your Groq API key now to save it to $RC_FILE (leave blank to skip): " API_KEY_INPUT || API_KEY_INPUT=""
        if [[ -n "${API_KEY_INPUT:-}" ]]; then
            {
                echo "export GROQ_API_KEY=\"$API_KEY_INPUT\""
            } >> "$RC_FILE"
            ok "Saved GROQ_API_KEY to $RC_FILE"
        else
            info "Skipped. You can add it later with: export GROQ_API_KEY=\"YOUR_KEY\""
        fi
    fi
else
    ok "GROQ_API_KEY is already set"
fi

echo ""
ok "Setup complete! Open a new terminal (or 'source $RC_FILE') and try: ai \"hello\""
