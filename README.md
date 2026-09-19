# dotfiles

Personal shell/git config and CLI tools, managed with [chezmoi](https://chezmoi.io)
and [mise](https://mise.jdx.dev). Works on macOS, WSL and in any devcontainer.

| File (in `home/`)                            | Deployed to                  |
| -------------------------------------------- | ---------------------------- |
| `dot_zshrc.tmpl`                             | `~/.zshrc`                   |
| `dot_config/git/config.tmpl`                 | `~/.config/git/config`       |
| `dot_config/mise/config.toml`                | `~/.config/mise/config.toml` |
| `dot_config/mise/config.local.toml`          | `~/.config/mise/config.local.toml` (macOS only; host-only tools, see below) |
| `dot_config/starship.toml`                   | `~/.config/starship.toml`    |
| `private_dot_ssh/gh-personal.pub`, `gh-aim.pub` | `~/.ssh/` (public keys only, to pick a GitHub key per repo) |
| `.chezmoi.toml.tmpl`                         | `~/.config/chezmoi/chezmoi.toml` (git name/email) |
| `run_onchange_after_10-mise-install.sh.tmpl` | runs `mise install` when the tool list changes |
| `.chezmoiexternal.toml`                      | zsh-autosuggestions + zsh-syntax-highlighting in `~/.local/share/zsh/plugins` (refreshed weekly) |
| `dot_wezterm.lua`                            | `~/.wezterm.lua` (macOS only) |
| `dot_config/1Password/ssh/agent.toml`        | `~/.config/1Password/ssh/agent.toml` (macOS only; key/vault references only, no secrets) |
| `dot_config/homebrew/Brewfile`               | `~/.config/homebrew/Brewfile` (macOS only) |
| `run_onchange_before_05-brew-bundle.sh.tmpl` | installs Homebrew if missing and runs `brew bundle` when the Brewfile changes (macOS only, no-op elsewhere) |
| `Library/Application Support/Code/User/settings.json` | same path under `~/` (macOS only; VS Code desktop settings) |

`install.sh` at the repo root is the bootstrap entry point for DevPod,
VS Code Dev Containers and Codespaces.

Personal tools (shared by host + every devcontainer): apm, awscli, azure-cli,
bat, chezmoi, claude-code, delta, eza, fd, fzf, gh, git-lfs, jq, lazygit,
mkcert, neovim, powershell, rclone, ripgrep, starship, tlrc, uv, yq, zoxide.
Project-specific tools (dotnet, ...) stay in each project's `mise.toml`.

Host-only tools (mise auto-loads `config.local.toml` alongside `config.toml`;
chezmoi only deploys it on macOS, so it never reaches a devcontainer):
devcontainer — installing the `devcontainer` CLI *inside* a devcontainer is a
nested-container edge case, not the norm, so it's Mac-only.

## macOS host: Homebrew

Homebrew is kept for GUI apps/casks and CLI tools mise doesn't cover (see
`dot_config/homebrew/Brewfile`), applied automatically by
`run_onchange_before_05-brew-bundle.sh.tmpl` whenever the Brewfile changes.
To add something:

- A CLI tool mise supports (check `mise registry`) → add it to
  `dot_config/mise/config.toml` instead, so it's shared with devcontainers too.
- A GUI app/cask, or a CLI tool mise doesn't support → add it to the Brewfile.

`~/.aws/config` is intentionally *not* managed here — it has real AWS account
IDs and SSO details that don't belong in a public repo as plain text; set it
up by hand on the Mac (or template it with `onepasswordRead` later).

Git config lives in `~/.config/git/config` (not `~/.gitconfig`) so it never
overwrites the credential helper DevPod / VS Code inject into `~/.gitconfig`.

Machine-specific shell tweaks that shouldn't be shared go in `~/.zshrc.local`.

## Prompt

starship everywhere (except Apple Terminal, which doesn't render it well).

The starship config is a two-line powerline prompt: directory and git status
as connected blocks, mise-managed language versions, AWS profile and command
duration on line one; exit code and prompt character on line two. It uses
Nerd Font icons, so set a [Nerd Font](https://www.nerdfonts.com) in your
terminal. Preview changes with `starship prompt`.

## DevPod

Use these dotfiles for every workspace:

```sh
devpod context set-options -o DOTFILES_URL=https://github.com/nirisarri/dotfiles
```

or for a single workspace: `devpod up . --dotfiles https://github.com/nirisarri/dotfiles`.

DevPod clones the repo in the container and runs `install.sh`, which installs
chezmoi (via mise if available) and applies the dotfiles.

VS Code Dev Containers: set `"dotfiles.repository": "nirisarri/dotfiles"` in your user settings.

With no TTY, the git identity falls back to `$GIT_AUTHOR_NAME` / `$GIT_AUTHOR_EMAIL`,
then to placeholders; DevPod's copied `~/.gitconfig` wins either way.

## macOS host

```sh
cp ~/.zshrc ~/.zshrc.bak; cp ~/.gitconfig ~/.gitconfig.bak
chezmoi init --apply nirisarri      # or: sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply nirisarri
```

You'll be asked for your git name/email once. Afterwards, empty (or trim)
`~/.gitconfig`: git reads it after `~/.config/git/config`, so anything left
there overrides the managed config.

## Day to day

```sh
chezmoi edit ~/.zshrc     # edit the source, then:
chezmoi apply             # deploy
chezmoi cd                # jump to the repo to commit/push
chezmoi update            # pull + apply on another machine
```
