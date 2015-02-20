#!/usr/bin/env bash
# CarryBag helper functions

set -e

RUNCOM_ADD_TOKEN="# CarryBag configuration"

_bash_runcom () {

    case "$OSTYPE" in
        darwin*)    echo ~/.bash_profile ;;
        *)          echo ~/.bashrc ;;
    esac
}

_add_to_bash_runcom () {

    local text="$*"
    local BASHRC=$(_bash_runcom)

    grep "$RUNCOM_ADD_TOKEN" "$BASHRC" >/dev/null || {
        sed -e "/# Load Bash It/i\\
$RUNCOM_ADD_TOKEN\\
\\
" "$BASHRC" > "$BASHRC.tmp" && mv "$BASHRC.tmp" "$BASHRC"
    }

    sed -e "/$RUNCOM_ADD_TOKEN/a\\
$text" "$BASHRC" > "$BASHRC.tmp" && mv "$BASHRC.tmp" "$BASHRC"
}

_build_carrybag_bash_runcom () {

    local BASHRC=$(_bash_runcom)

    [ -w "$BASHRC" ] && cp "$BASHRC" "$BASHRC.bak" &&
        echo -e "${echo_cyan}Your $(basename "$BASHRC") has been backed up to $BASHRC.bak${echo_normal}"
    cp "$BASH_IT/template/bash_profile.template.bash" "$BASHRC"

    _add_to_bash_runcom "export BASHRC=\'$BASHRC\'"
    _add_to_bash_runcom "export MANPATH=\'/usr/local/man:$MANPATH\'"
    _add_to_bash_runcom "export BASH_IT_THEME='alister'"
    _add_to_bash_runcom "export EDITOR='vim'"
    _add_to_bash_runcom "export GIT_EDITOR='vim'"
    _add_to_bash_runcom "set -o vi"
    _add_to_bash_runcom "HISTCONTROL=ignoreboth"
    _add_to_bash_runcom "shopt -s cdspell"
    _add_to_bash_runcom "shopt -s histappend"
    _add_to_bash_runcom "shopt -s dotglob"
    _add_to_bash_runcom "shopt -s checkwinsize"

    echo -e "${echo_cyan}CarryBag modifications have been applied to $(basename "$BASHRC")${echo_normal}"
}
