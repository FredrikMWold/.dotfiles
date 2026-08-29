# Omarchy companion skill

Whenever a task requires invoking the `omarchy` skill, also invoke
`omarchy-config-scope` before making changes. Use it to classify persistent
configuration as shared or machine-specific and to manage dotfiles symlinks
only with the user's explicit approval.

Do not modify or replace the packaged Omarchy skill under
`/usr/share/omarchy/` or its symlink in `~/.agents/skills/omarchy`.
