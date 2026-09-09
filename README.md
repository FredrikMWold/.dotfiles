## Installation

```bash
git clone --recursive-submodules https://github.com/FredrikMWold/.dotfiles.git
cd .dotfiles
./config/bin/dotfiles
```

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