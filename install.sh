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

# Dev container base images can leave root-owned lock files in a shared /tmp
# (e.g. /tmp/stable-async.pid.lock), which makes the run_onchange hooks fail
# with EACCES. Give this run a private, user-owned temp dir.
TMPDIR="${TMPDIR:-$HOME/.cache/tmp}"
mkdir -p "$TMPDIR"
export TMPDIR

# --force: overwrite files the base image already put in $HOME (e.g. ~/.zshrc)
# without prompting; there is no TTY when DevPod runs this.
exec "$@" init --apply --force --source="$script_dir"
