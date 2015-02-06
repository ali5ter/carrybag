#!/usr/bin/env bash

set -e

_bash_runcom() {
    case "$OSTYPE" in
        darwin*)    echo ~/.bash_profile ;;
        *)          echo =~/.bashrc ;;
    esac
}

_build_carrybag_bash_runcom() {

    local BASHRC=$(_bash_runcom)

    [ -w "$BASHRC" ] && cp "$BASHRC" "$BASHRC.bak" &&
        echo -e "${echo_cyan}Your $BASHRC has been backed up to $BASHRC.bak$echo_normal"
    cp "$BASH_IT/template/bash_profile.template.bash" "$BASHRC"

    sed -e s/bobby/alister/ "$BASHRC" > "$BASHRC.tmp" && mv "$BASHRC.tmp" "$BASHRC"
    sed -e s/\\/usr\\/bin\\/mate\ -w/vim/g "$BASHRC" > "$BASHRC.tmp" && mv "$BASHRC.tmp" "$BASHRC"

    ## TODO: Move to carrybag-private
    sed -e s/git@git.domain.com/git@gitlab.different.com/ "$BASHRC" > "$BASHRC.tmp" && mv "$BASHRC.tmp" "$BASHRC"
}

_preload_carrybag_additions() {

    for file in $CB_BASE/themes/*; do
        _file=$(basename $file)
        [ -e "$BASH_IT/themes/$_file" ] && rm -f "$BASH_IT/themes/$_file"
        cp -r "$file" "$BASH_IT/themes/$_file"
    done

    for ftype in "aliases" "completion" "plugins"; do
        for file in $CB_BASE/$ftype/*; do
            _file=$(basename $file)
            [ -e "$BASH_IT/available/$_file" ] && rm -f "$BASH_IT/available/$_file"
            cp "$file" "$BASH_IT/$ftype/available/$_file"
        done
    done
}
