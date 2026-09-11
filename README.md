# dotfiles

Personal shell/git config and CLI tools, managed with [chezmoi](https://chezmoi.io)
and [mise](https://mise.jdx.dev). Works on macOS and in any devcontainer.

| File (in `home/`)                          | Deployed to                  |
| ------------------------------------------ | ---------------------------- |
| `dot_zshrc.tmpl`                           | `~/.zshrc`                   |
| `dot_config/git/config.tmpl`               | `~/.config/git/config`       |
| `dot_config/mise/config.toml`              | `~/.config/mise/config.toml` |
| `run_onchange_after_10-mise-install.sh.tmpl` | runs `mise install` when the tool list changes |
| `.chezmoiexternal.toml`                    | zsh-autosuggestions + zsh-syntax-highlighting in `~/.local/share/zsh/plugins` |

Personal tools: bat, chezmoi, claude-code, delta, eza, fd, fzf, jq, ripgrep, starship, yq, zoxide.

Prompt: oh-my-posh when `~/.config/oh-my-posh/nicpowerline_linux.omp.json` exists
(the Mac), starship everywhere else.
Project tools (dotnet, gh, az, ...) stay in each project's `mise.toml`.

Git config lives in `~/.config/git/config` (not `~/.gitconfig`) so it never
overwrites the credential helper DevPod / VS Code inject into `~/.gitconfig`.

## DevPod

Use these dotfiles for every workspace:

```sh
devpod context set-options -o DOTFILES_URL=https://github.com/<you>/dotfiles
```

or for a single workspace: `devpod up . --dotfiles https://github.com/<you>/dotfiles`.

DevPod clones the repo in the container and runs `install.sh`, which installs
chezmoi (via mise if available) and applies the dotfiles.

VS Code Dev Containers: set `"dotfiles.repository": "<you>/dotfiles"` in your user settings.

## macOS host

```sh
cp ~/.zshrc ~/.zshrc.bak; cp ~/.gitconfig ~/.gitconfig.bak
chezmoi init --apply <you>          # or: sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply <you>
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
