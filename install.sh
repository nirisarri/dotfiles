#!/bin/sh
# Entry point run automatically by DevPod, VS Code Dev Containers and Codespaces
# after cloning this repo. Also works for bootstrapping any machine from a clone.
set -eu

script_dir="$(cd -P -- "$(dirname -- "$0")" && pwd -P)"

if command -v chezmoi >/dev/null 2>&1; then
  set -- chezmoi
elif command -v mise >/dev/null 2>&1; then
  set -- mise exec chezmoi@latest -- chezmoi
else
  bin_dir="$HOME/.local/bin"
  sh -c "$(curl -fsSL https://get.chezmoi.io)" -- -b "$bin_dir"
  set -- "$bin_dir/chezmoi"
fi

# --force: overwrite files the base image already put in $HOME (e.g. ~/.zshrc)
# without prompting; there is no TTY when DevPod runs this.
exec "$@" init --apply --force --source="$script_dir"
