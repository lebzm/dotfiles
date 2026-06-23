#!/usr/bin/env bash

set -euo pipefail

REPO_URL="https://github.com/lebzm/dotfiles.git"
REPO_DIR="$HOME/.config/dotfiles"

# ─── Helpers ─────────────────────────────────────────────────────────────────

info() {
  printf "\033[34m→ %s\033[0m\n" "$1"
}

success() {
  printf "\033[32m✓ %s\033[0m\n" "$1"
}

error() {
  printf "\033[31m✗ %s\033[0m\n" "$1" >&2
  exit 1
}

warn() {
  printf "\033[33m⚠ %s\033[0m\n" "$1"
}

# ─── Preconditions ───────────────────────────────────────────────────────────

info "Checking prerequisites..."

if [ "$(uname -s)" != "Darwin" ]; then
  error "This dotfiles is designed for macOS only."
fi

if [ "$(uname -m)" != "arm64" ]; then
  error "This dotfiles is designed for Apple Silicon (aarch64) only."
fi

command -v git >/dev/null 2>&1 || error "git is required but not installed."
command -v curl >/dev/null 2>&1 || error "curl is required but not installed."

success "Prerequisites OK"

# ─── Clone repository ────────────────────────────────────────────────────────

if [ -d "$REPO_DIR" ]; then
  info "Repository already exists at $REPO_DIR"
else
  info "Cloning dotfiles repository..."
  git clone "$REPO_URL" "$REPO_DIR"
  success "Repository cloned to $REPO_DIR"
fi

cd "$REPO_DIR"

# ─── Install Lix (Nix) ───────────────────────────────────────────────────────

if command -v nix >/dev/null 2>&1; then
  success "Lix/Nix is already installed"
else
  info "Installing Lix (modern Nix implementation)..."
  curl -sSf -L https://install.lix.systems/lix | sh -s -- install --no-confirm
  success "Lix installed"

  info "Loading Nix environment..."
  if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    # shellcheck disable=SC1091
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  elif [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    # shellcheck disable=SC1091
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
  fi

  if ! command -v nix >/dev/null 2>&1; then
    warn "Please open a new terminal window to make 'nix' available, then re-run this script."
    exit 1
  fi
fi

# ─── Install nix-darwin ──────────────────────────────────────────────────────

HOSTNAME=$(hostname -s)

info "Installing nix-darwin system configuration for '$HOSTNAME'..."
sudo nix run nix-darwin -- switch --flake ".#$HOSTNAME"
success "nix-darwin installed and system configuration applied"

# ─── Install home-manager ────────────────────────────────────────────────────

USER=$(whoami)

info "Installing home-manager user configuration for '$USER'..."
home-manager switch --flake ".#$USER"
success "home-manager installed and user configuration applied"

# ─── Post-install ────────────────────────────────────────────────────────────

success "Bootstrap complete! 🎉"
echo ""
echo "Next steps:"
echo "  1. Restart your terminal"
echo "  2. Verify with: nix --version"
echo "  3. Run day-to-day tasks with mise:"
echo "       mise system"
echo "       mise home"
echo "       mise build"
echo "       mise gc"
echo ""
echo "  See .mise.toml for available tasks."
