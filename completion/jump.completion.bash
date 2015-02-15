#!/usr/bin/env bash
# Jump bookmark name completion

_jump_complete () {

    local cur="${COMP_WORDS[COMP_CWORD]}"
    local bookmarks=$(awk -F'::' '{print $1}' "$HOME"/.jump/bookmarks)

    COMPREPLY=( $(compgen -W "${bookmarks}" -- "${cur}") )
    return 0
}

complete -o default -o nospace -F _jump_complete jump
