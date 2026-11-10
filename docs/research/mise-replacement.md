# Mise migration: condensed assessment

**Baseline:** `hyprland` is treated as main. System audit performed on 2026-11-06 against installed Omarchy 4.5.0-3; shell assessment updated on 2026-11-07. No system configuration was changed by this research.

## Verdict

**Yes: mise can replace the installer and GNU Stow, and its setup/history workflow can replace this repository's management role.** Configuration files, custom scripts, and Git-backed storage still need to exist.

Use **`mise bootstrap`** for packages, tools, services, and source checkouts; **`mise dotfiles`** for reviewed configuration and its history. Both are stable features. Mise does **not** automatically discover customizations against Omarchy defaults: it tracks only declared resources and enrolled files. [Bootstrap](https://mise.jdx.dev/bootstrap.html) · [Dotfiles](https://mise.jdx.dev/dotfiles.html)

## What the system audit found

**Shell update:** Zsh/Oh My Zsh/Powerlevel10k has been replaced by **Bash + Starship + ble.sh**, bringing the setup closer to Omarchy defaults. Bash and Starship reuse Omarchy's shell initialization; ble.sh remains an added integration. Migrate the remaining Bash overrides and ble.sh setup, not the old Zsh stack. Sources: live `~/.dotfiles/home/.bashrc`; `/usr/share/omarchy/default/bash/{rc,init}`.

The counts below remain the **2026-11-06 snapshot**, not a fresh inventory after the shell change.

| Comparison | Result |
|---|---|
| Installed packages | 1,127 total; 207 explicitly installed |
| Explicit packages outside the reconstructed Omarchy baseline | 37 candidates, including legitimate optional apps and build prerequisites |
| Shipped Omarchy user-config templates | 49 compared: 24 identical, 25 different |
| Installed Neovim configuration seeds | 20 compared: 18 identical, two different |

**Different does not mean personally customized.** Differences include generated font settings, application-version drift, comments, and inactive samples.

| Treatment | Settings and applications |
|---|---|
| **Already shared; preserve** | Generic Hyprland Lua bases, bindings/input/appearance, current Bash overrides and ble.sh integration, Kitty and VS Code settings |
| **Additional sharing candidates** | FiraCode font choice; Btop refresh/sort/tree preferences; Herdr agent sorting; preferred browser/editor/terminal; optional application and development modules |
| **Keep machine-specific** | Monitor layouts/scaling, GPU/kernel/boot settings, device plugins and services, hardware-oriented Btop layout |
| **Do not capture as personal config** | Stock Neovim line-number/autoformat/clipboard behavior, stock terminal key encodings, generated themes, receipts, backups, caches, sessions, and histories |
| **Keep out of ordinary shared history** | Credentials, private account/profile data, and service secrets |

Useful application declarations include the custom VS Code build, Discord, creative tools, gaming/media choices, and optional dictation. Declare **desired apps and prerequisites**, not every dependency package.

Review-only discrepancies include missing core entries `fcitx5-table-extra` and `superwhisper-bin`, and a disabled Docker socket with its service enabled. These are not automatic repair recommendations.

## Recommended design

**Prefer a mise-managed setup/history repository** if the goal is to retire Stow and the legacy repository structure. Enroll the global mise configuration alongside selected live files so adoption can restore configuration and run bootstrap. Keeping the existing Stow-shaped repository with mise groups is a lower-disruption alternative. [Setup adoption](https://mise.jdx.dev/bootstrap/from-repository.html) · [Stow-compatible groups](https://mise.jdx.dev/dotfiles/groups.html)

| Sharing scope | Mise mechanism |
|---|---|
| Shared between computers | `mode = "track"` |
| Machine-specific, remotely backed up | `mode = "track"` with `variants = [{ machine = true }]` |
| Strictly local; never pushed | `mode = "track-local"` |

**Machine-specific is not the same as private/local-only:** machine variants reach the remote origin, although they are not applied to other machines. [History](https://mise.jdx.dev/dotfiles/history.html)

Before migration, reconcile the active global mise file with the `hyprland` branch's tracked version, preserve ignored-local Lua overlays and their base-first imports, and retain custom script/build payloads. Do not import obsolete `master` configuration. The canonical branch's inherited APT installer is not a reliable specification of this Omarchy system. [Canonical repository](https://github.com/FredrikMWold/.dotfiles/tree/391eb0c572193809a350fa43df2dd057fddf73ae)

Test mappings before live deployment: existing symlinks can be retargeted, `--force` is not a backup, and any retained submodules need deployment verification. Do not retain obsolete Zsh plugin/theme dependencies merely because they remain in the repository. [Deployment behavior](https://mise.jdx.dev/dotfiles/managed.html)

## Coverage limit

All pacman packages and shipped configuration templates were covered, with additional application, service, and safe system-file checks. Private profiles/databases, credentials, project dependencies, containers, and arbitrary installation prefixes were not exhaustively inspected. Package presence or template equality does not establish that every application setting is stock.

Full metadata remains in the session's `config-audit.json` and `package-audit.json`. **Recommendation: migrate reviewed desired state, not the entire discovered filesystem.**
