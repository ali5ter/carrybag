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

    ## Use Bash-it runcom as a template
    [ -w "$BASHRC" ] && cp "$BASHRC" "$BASHRC.bak" &&
        echo -e "${echo_cyan}Your $(basename "$BASHRC") has been backed up to $BASHRC.bak${echo_normal}"
    cp "$BASH_IT/template/bash_profile.template.bash" "$BASHRC"

    ## Persist the OS specific bash runcom name
    _add_to_bash_runcom "export BASHRC=\'$BASHRC\'"

    ## Include man pages added by package managers
    _add_to_bash_runcom "export MANPATH=\'/usr/local/man:$MANPATH\'"

    ## Use the Bash-it theme provided by CarryBag
    _add_to_bash_runcom "export BASH_IT_THEME='alister'"

    ## Make our default editor vim
    _add_to_bash_runcom "export EDITOR='vim'"

    ## Make sure git uses the same edtor
    _add_to_bash_runcom "export GIT_EDITOR=\'$EDITOR\'"

    ## Use vim to edit on the cmdl
    _add_to_bash_runcom "set -o vi"

    ## Avoid storing duplicate command and those starting with spaces
    _add_to_bash_runcom "HISTCONTROL=ignoreboth"

    ## Help correct minor typos when changing directories
    _add_to_bash_runcom "shopt -s cdspell"

    ## Append commands to the history instead of overwriting when exiting
    _add_to_bash_runcom "shopt -s histappend"

    ## Include dot files in pathname expansion (globbing)
    _add_to_bash_runcom "shopt -s dotglob"

    ## Update window size vars after each command
    _add_to_bash_runcom "shopt -s checkwinsize"

    echo -e "${echo_cyan}CarryBag modifications have been applied to $(basename "$BASHRC")${echo_normal}"
}
