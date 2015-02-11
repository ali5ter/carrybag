#!/usr/bin/env bash
# CarryBag helper functions

set -e

_bash_runcom () {
    case "$OSTYPE" in
        darwin*)    echo ~/.bash_profile ;;
        *)          echo =~/.bashrc ;;
    esac
}

_build_carrybag_bash_runcom () {

    local BASHRC=$(_bash_runcom)

    [ -w "$BASHRC" ] && cp "$BASHRC" "$BASHRC.bak" &&
        echo -e "${echo_cyan}Your $(basename $BASHRC) has been backed up to $BASHRC.bak$echo_normal"
    cp "$BASH_IT/template/bash_profile.template.bash" "$BASHRC"

    sed -e s/bobby/alister/ "$BASHRC" > "$BASHRC.tmp" && mv "$BASHRC.tmp" "$BASHRC"
    sed -e s/\\/usr\\/bin\\/mate\ -w/vim/g "$BASHRC" > "$BASHRC.tmp" && mv "$BASHRC.tmp" "$BASHRC"

    ## TODO: Move to carrybag-private
    sed -e s/git@git.domain.com/git@gitlab.different.com/ "$BASHRC" > "$BASHRC.tmp" && mv "$BASHRC.tmp" "$BASHRC"

    echo -e "${echo_cyan}CarryBag modifications have been applied to $(basename $BASHRC)$echo_normal"
}

_preload_carrybag_themes () {

    echo -e "${echo_cyan}Copy CarryBag themes to Bash It:$echo_normal"
    for file in $CB_BASE/themes/*; do
        _file=$(basename $file)
        echo -e "\t${echo_green}$_file$echo_normal"
        [ -e "$BASH_IT/themes/$_file" ] && rm -f "$BASH_IT/themes/$_file"
        cp -r "$file" "$BASH_IT/themes/$_file"
    done
}

_preload_carrybag_addons () {

    echo -e "${echo_cyan}Copy CarryBag addons to Bash It:$echo_normal"
    for ftype in "aliases" "completion" "plugins"; do
        for file in $CB_BASE/$ftype/*; do
            _file=$(basename $file)
            echo -e "\t${echo_cyan}$ftype ${echo_green}$(echo $_file | cut -d'.' -f 1)$echo_normal"
            [ -e "$BASH_IT/available/$_file" ] && rm -f "$BASH_IT/available/$_file"
            cp "$file" "$BASH_IT/$ftype/available/$_file"
        done
    done
}

_bash-it-enable () {
    local type=$1
    local addon=$2
    bash-it enable $type $addon >/dev/null &&
        echo -e "\t${echo_cyan}$type ${echo_green}$addon$echo_normal"
}
