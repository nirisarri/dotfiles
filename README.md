# dotfiles

Personal shell/git config and CLI tools, managed with [chezmoi](https://chezmoi.io)
and [mise](https://mise.jdx.dev). Works on macOS, WSL and in any devcontainer.

| File (in `home/`)                            | Deployed to                  |
| -------------------------------------------- | ---------------------------- |
| `dot_zshrc.tmpl`                             | `~/.zshrc`                   |
| `dot_config/git/config.tmpl`                 | `~/.config/git/config`       |
| `dot_config/mise/config.toml`                | `~/.config/mise/config.toml` |
| `dot_config/starship.toml`                   | `~/.config/starship.toml`    |
| `.chezmoi.toml.tmpl`                         | `~/.config/chezmoi/chezmoi.toml` (git name/email) |
| `run_onchange_after_10-mise-install.sh.tmpl` | runs `mise install` when the tool list changes |
| `.chezmoiexternal.toml`                      | zsh-autosuggestions + zsh-syntax-highlighting in `~/.local/share/zsh/plugins` (refreshed weekly) |

`install.sh` at the repo root is the bootstrap entry point for DevPod,
VS Code Dev Containers and Codespaces.

Personal tools: bat, chezmoi, claude-code, delta, eza, fd, fzf, jq, ripgrep, starship, yq, zoxide.
Project tools (dotnet, gh, az, ...) stay in each project's `mise.toml`.

Git config lives in `~/.config/git/config` (not `~/.gitconfig`) so it never
overwrites the credential helper DevPod / VS Code inject into `~/.gitconfig`.

Machine-specific shell tweaks that shouldn't be shared go in `~/.zshrc.local`.

## Prompt

oh-my-posh when `~/.config/oh-my-posh/nicpowerline_linux.omp.json` exists
(the Mac), starship everywhere else (neither in Apple Terminal).

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
