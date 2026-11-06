# Omarchy environment (OMARCHY_PATH + PATH), needed even for non-interactive shells
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap
[[ $- != *i* ]] && return

if [[ ${TERM:-} != dumb ]]; then
  source /usr/share/blesh/ble.sh --attach=none
fi

# Let ble.sh install compatible fzf widgets instead of the Readline bindings.
FZF_CTRL_R_COMMAND= FZF_CTRL_T_COMMAND= FZF_ALT_C_COMMAND= \
  source "$OMARCHY_PATH/default/bash/rc"

if [[ ${BLE_VERSION-} ]]; then
  ble-import integration/fzf-key-bindings
fi

[[ ! -r "$HOME/.atuin/bin/env" ]] || source "$HOME/.atuin/bin/env"
eval "$(atuin init bash --disable-up-arrow --disable-ai)"

alias cd='z'
alias ll='eza -lha'

npmi() {
  vicinae 'vicinae://launch/@FredrikMWold/store.vicinae.npm/npm-install?arguments={"path":"'"$(pwd)"'"}'
}

npmr() {
  vicinae 'vicinae://launch/@FredrikMWold/store.vicinae.npm/npm-uninstall?arguments={"path":"'"$(pwd)"'"}'
}

npmu() {
  vicinae 'vicinae://launch/@FredrikMWold/store.vicinae.npm/npm-update?arguments={"path":"'"$(pwd)"'"}'
}

cc() {
  if [ -n "$1" ]; then
    cd "$1" && /usr/bin/code .
  else
    /usr/bin/code .
  fi
}

[[ ! ${BLE_VERSION-} ]] || ble-attach
