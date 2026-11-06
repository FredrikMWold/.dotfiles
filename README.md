## Installation

```bash
git clone https://github.com/FredrikMWold/.dotfiles.git
cd .dotfiles
./config/bin/dotfiles
```

No Git submodules are required.

## Omarchy terminal shell

The shared shell uses Omarchy's packaged Bash defaults, Starship, ble.sh, and
Atuin. Install Starship with `omarchy pkg add starship` and ble.sh with
`omarchy pkg aur add blesh-git`; Atuin, mise, and zoxide must also be installed.
The general installation script above is a legacy apt-based installer, not an
Omarchy setup command.

Preview the shell links with
`stow --no --verbose=2 --restow --dir="$HOME/.dotfiles" --target="$HOME" home starship`,
then apply the same command without `--no` after resolving any conflicts.
`home/.bashrc`, `home/.bash_profile`, `home/.profile`, `home/.blerc`, and
`starship/.config/starship.toml` are shared; package installation and the login
shell are machine-local.

Bash loads ble.sh before Omarchy initializes Starship, mise, and zoxide.
ble.sh provides syntax highlighting and inline suggestions; Atuin provides
Ctrl-R history search and a suggestion source, leaving the Up arrow unchanged.
The prompt retains the compact Powerline layout with a right-aligned status
and clock, without cloud account or infrastructure context. The `oh-my-zsh`
package is retired and must not be stowed.
There is no Bun, NVM, or Vite+ shell initialization.

## Custom VS Code

Run `update-custom-vscode` from `~/bin` (stowed from `scripts/bin`) to clone `FredrikMWold/vscode` into `~/vscode` if needed, fetch the latest stable upstream release, rebase the single custom commit onto that release tag, and run `npm run build-and-install`. The branch stays named `custom` and tracks `origin/custom` on your fork, not Microsoft's release branch.

Fresh clones start from the published `custom` branch. Existing checkouts use their local `custom` branch, or create it from `origin/custom` if needed. The updater requires Git with SSH access to the fork, GitHub CLI, and the Node/npm and Arch build prerequisites checked by the repository's build script. The build script asks for confirmation before installing the package.

The updater refuses dirty checkouts and creates a local `backup/custom-vscode-*` tag before changing the custom history; it does not create release or backup branches. Rebase conflicts stop the update before building; resolve them and run `git rebase --continue`, or cancel with `git rebase --abort`. It never pushes branches or tags. After rebasing, publish your updated branch manually with `git push --force-with-lease` from `~/vscode`; normal new commits use `git push`. Use `update-custom-vscode --no-install` to build the package without installing it.

## Hyprland configuration

Files named `hyprland/.config/hypr/_*.lua` are shared across computers and
stowed into `~/.config/hypr/`. The regular `*.lua` files are machine-local,
ignored by Git, stowed into `~/.config/hypr/`, and import their matching shared
base as their first statement:

```lua
dofile(os.getenv("HOME") .. "/.config/hypr/_bindings.lua")
```

Put generic bindings, window rules, input settings, appearance, and monitor
defaults in the underscored files. Put hardware-specific settings and local
tool integrations after the import in the regular files so they override the
shared defaults. Each computer keeps its own ignored regular files in the
dotfiles worktree, providing one place to find all Hyprland configuration
without committing machine-specific settings.