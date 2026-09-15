#!/bin/sh
# Entry point run automatically by DevPod, VS Code Dev Containers and Codespaces
# after cloning this repo. Also works for bootstrapping any machine from a clone.
set -eu

script_dir="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"

# A mise shim named `chezmoi` can sit on PATH with no version selected, so
# `command -v` is not a reliable probe: actually run the binary. Don't route
# through `mise exec chezmoi@latest` either -- resolving "latest" downloads a
# ~12MB GitHub releases listing that regularly exceeds mise's 10s fetch timeout
# inside a container, which fails the whole bootstrap.
if chezmoi --version >/dev/null 2>&1; then
  set -- chezmoi
else
  bin_dir="$HOME/.local/bin"
  mkdir -p "$bin_dir"
  sh -c "$(curl -fsSL https://get.chezmoi.io)" -- -b "$bin_dir"
  set -- "$bin_dir/chezmoi"
fi

# The dotfiles (~/.zshrc, prompt, plugins) target zsh, but slim base images
# (Debian/Ubuntu/Alpine devcontainers) often ship only bash. Make sure zsh is
# installed and is this user's login shell before applying anything.
#
# zsh is a compiled shell, not a static binary in mise's registry, so it comes
# from the OS package manager. macOS already defaults to zsh, so this is really
# for Linux containers. Never let a failure here abort the bootstrap.
ensure_zsh() {
  zsh_bin="$(command -v zsh || true)"

  if [ -z "$zsh_bin" ]; then
    # Run package-manager commands as root only when we aren't already.
    if [ "$(id -u)" = "0" ]; then
      sudo=""
    elif command -v sudo >/dev/null 2>&1; then
      sudo="sudo"
    else
      echo "install.sh: zsh not installed and no root/sudo to install it; skipping." >&2
      return 0
    fi

    if command -v apt-get >/dev/null 2>&1; then
      $sudo apt-get update -qq && $sudo apt-get install -y -qq zsh
    elif command -v apk >/dev/null 2>&1; then
      $sudo apk add --no-cache zsh
    elif command -v dnf >/dev/null 2>&1; then
      $sudo dnf install -y zsh
    elif command -v yum >/dev/null 2>&1; then
      $sudo yum install -y zsh
    elif command -v pacman >/dev/null 2>&1; then
      $sudo pacman -Sy --noconfirm zsh
    elif command -v zypper >/dev/null 2>&1; then
      $sudo zypper install -y zsh
    elif command -v brew >/dev/null 2>&1; then
      brew install zsh
    else
      echo "install.sh: no known package manager to install zsh; skipping." >&2
      return 0
    fi

    zsh_bin="$(command -v zsh || true)"
    [ -z "$zsh_bin" ] && { echo "install.sh: zsh install failed; skipping chsh." >&2; return 0; }
  fi

  # Make zsh the login shell for this user if it isn't already.
  current_shell="${SHELL:-}"
  if [ "$current_shell" != "$zsh_bin" ]; then
    # chsh requires the shell to be listed in /etc/shells.
    if [ -w /etc/shells ] || [ "$(id -u)" = "0" ]; then
      grep -qxF "$zsh_bin" /etc/shells 2>/dev/null \
        || echo "$zsh_bin" | ${sudo:-} tee -a /etc/shells >/dev/null 2>&1 || true
    elif command -v sudo >/dev/null 2>&1; then
      grep -qxF "$zsh_bin" /etc/shells 2>/dev/null \
        || echo "$zsh_bin" | sudo tee -a /etc/shells >/dev/null 2>&1 || true
    fi

    if [ "$(id -u)" = "0" ]; then
      chsh -s "$zsh_bin" "$(id -un)" >/dev/null 2>&1 \
        || echo "install.sh: could not set zsh as login shell." >&2
    elif command -v sudo >/dev/null 2>&1; then
      sudo chsh -s "$zsh_bin" "$(id -un)" >/dev/null 2>&1 \
        || echo "install.sh: could not set zsh as login shell (chsh)." >&2
    else
      chsh -s "$zsh_bin" >/dev/null 2>&1 \
        || echo "install.sh: could not set zsh as login shell (needs privileges)." >&2
    fi
  fi
}

ensure_zsh

# Dev container base images can leave root-owned lock files in a shared /tmp
# (e.g. /tmp/stable-async.pid.lock), which makes the run_onchange hooks fail
# with EACCES. Give this run a private, user-owned temp dir.
TMPDIR="${TMPDIR:-$HOME/.cache/tmp}"
mkdir -p "$TMPDIR"
export TMPDIR

# --force: overwrite files the base image already put in $HOME (e.g. ~/.zshrc)
# without prompting; there is no TTY when DevPod runs this.
exec "$@" init --apply --force --source="$script_dir"
