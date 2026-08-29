---
name: omarchy-config-scope
description: >
  REQUIRED companion whenever the Omarchy skill is invoked. Before Omarchy
  configuration changes, determine whether each setting is shared across
  computers or machine-specific, ask the user when that boundary is unclear,
  and manage dotfiles symlinks only when explicitly requested. Covers
  ~/.dotfiles, GNU Stow, shared Hyprland underscore bases, local overlays,
  monitors, bindings, autostart, input, themes, terminals, and shell config.
---

# Omarchy Configuration Scope

Use this skill alongside the `omarchy` skill. This skill decides where a
configuration belongs; the Omarchy skill defines how to configure and validate
the component.

## Classify Before Editing

Inspect every affected path before changing it:

- Determine whether it is a regular file, symlink, or missing.
- Resolve symlink targets.
- Inspect the corresponding file and Git status under `~/.dotfiles`.
- Preserve unrelated or uncommitted user changes.

Then classify each persistent setting:

- **Shared:** intended to behave the same on every computer, such as generic
  keybindings, simple window rules, keyboard defaults, appearance, application
  preferences, and portable autostart entries.
- **Machine-specific:** tied to hardware, monitor names/layouts, laptop-only or
  desktop-only tools, host-specific paths, generated files, or services not
  installed everywhere.

If the classification is unclear or mixed, ask the user one focused question
before editing. Do not infer that a setting is shared merely because it is
currently in the dotfiles repository.

Commands that do not persist configuration, such as taking a screenshot or
showing reminders, need no shared-versus-local split.

## Require Explicit Dotfiles Approval

Classification and storage are separate decisions. Do not move a file into
`~/.dotfiles` or create a symlink unless the user explicitly asks for shared
dotfiles management or confirms it when asked.

When the user requests dotfiles management:

1. Use `~/.dotfiles` as the canonical repository.
2. Follow its GNU Stow layout:
   `~/.dotfiles/<package>/<path-relative-to-home>`.
3. Prefer the existing package for that application.
4. Preview with:
   `stow --no --verbose=2 --restow --dir="$HOME/.dotfiles" --target="$HOME" <package>`.
5. Resolve conflicts without overwriting files or adopting machine-local
   content.
6. Apply with the same command without `--no`.
7. Verify shared paths are symlinks into `~/.dotfiles` and machine-local paths
   are regular files.

Never stow an entire configuration directory when it contains a mix of shared
and machine-specific files. Stow the shared leaf files instead.

## Hyprland Layering Convention

For composable files in `~/.config/hypr/`:

- Shared Lua bases are named `_hyprland.lua`, `_bindings.lua`,
  `_monitors.lua`, `_input.lua`, `_looknfeel.lua`, and `_autostart.lua`.
- Those underscored files are symlinked from
  `~/.dotfiles/hyprland/.config/hypr/`.
- Regular files without the underscore are machine-local and must not be
  symlinks.
- The first statement in every machine-local file imports its matching base:

```lua
dofile(os.getenv("HOME") .. "/.config/hypr/_bindings.lua")
```

The base must load first so later machine-local declarations override shared
defaults. Put generic monitor fallback rules and five persistent workspaces in
`_monitors.lua`; keep named outputs, hardware layouts, and generated monitor
configuration local.

For formats that cannot import a base, choose either a whole-file shared
symlink or a whole-file local configuration. Do not invent fragile generated
layering. `xdph.conf` is currently intentionally shared as a direct symlink.

## Finish Safely

Use the Omarchy skill's component-specific reload and validation steps after
editing. Confirm that:

- every local overlay imports its base first;
- shared files resolve into `~/.dotfiles`;
- local files are not symlinks;
- no machine-specific values leaked into shared files;
- the target application accepts the resulting configuration.
