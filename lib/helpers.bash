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

_preload_carrybag_themes () {

    echo -e "${echo_cyan}Copy CarryBag themes to Bash It:${echo_normal}"

    for file in $CB_BASE/themes/*; do
        _file=$(basename "$file")
        [ "$_file" == '*' ] || {
            echo -e "\t${echo_green}$_file$echo_normal"
            [ -e "$BASH_IT/themes/$_file" ] && rm -f "$BASH_IT/themes/$_file"
            cp -r "$file" "$BASH_IT/themes/$_file"
        }
    done
}

_preload_carrybag_addons () {

    echo -e "${echo_cyan}Copy CarryBag addons to Bash It:$echo_normal"

    for ftype in "aliases" "completion" "plugins"; do
        for file in $CB_BASE/$ftype/*; do
            _file=$(basename "$file")
            [ "$_file" == '*' ] || {
                echo -e "\t${echo_cyan}$ftype ${echo_green}$(echo "$_file" | cut -d'.' -f 1)${echo_normal}"
                [ -e "$BASH_IT/available/$_file" ] && rm -f "$BASH_IT/available/$_file"
                cp "$file" "$BASH_IT/$ftype/available/$_file"
            }
        done
    done
}

_bash-it-enable () {

    local type=$1
    local addon=$2

    bash-it enable "$type" "$addon" >/dev/null &&
        echo -e "\t${echo_cyan}$type ${echo_green}$addon${echo_normal}"
}

_update_git_user_name () {

    local fullname

    case "$OSTYPE" in
        darwin*)    fullname="$(finger "$(whoami)" | awk -F: '{ print $3 }' | head -n1 | sed 's/^ //')" ;;
        *)          fullname="$USER" ;;
    esac

    echo -ne "${echo_yellow}What name do you want attached to your git commits? [$fullname] ${echo_normal}"
    read reply
    case "$reply" in
        '') ;;
        *)  fullname="$reply" ;;
    esac

    git config --global user.name "$fullname"
}

_update_git_user_email() {

    local email

    while true; do
        echo -ne "${echo_yellow}What email address do you want attached to your git commits? ${echo_normal}"
        read reply
        case "$reply" in
            '') ;;
            *) email="$reply"; break ;;
        esac
    done

    # TODO: Validate email address
    git config --global user.email "$email"
}

_update_git_platform_mods () {

    case "$OSTYPE" in
        darwin*)
            [ -s /Applications/SourceTree.app ] && {
                git config --global difftool.sourcetree.cmd 'opendiff "$LOCAL" "$REMOTE"'
                git config --global difftool.sourcetree.path ''
                git config --global mergetool.sourcetree.cmd '/Applications/SourceTree.app/Contents/Resources/opendiff-w.sh "$LOCAL" "$REMOTE" -ancestor "$BASE" -merge "$MERGED"'
                git config --global mergetool.sourcetree.trustExitCode true
            }
            ;;
        *)
            command -v meld >/dev/null && {
                git config --global merge.tool meld
                git config --global mergetool.meld.cmd 'meld $BASE $LOCAL $REMOTE $MERGED'
                git config --global mergetool.meld.trustExitCode false
                git config --global diff.tool meld
                git config --global difftool.meld.cmd 'meld $LOCAL $REMOTE'
            }
            ;;
    esac
}

_build_carrybag_git_config () {

    local gitconfig=~/.gitconfig

    ## Create a basic gitconfig file
    [ -w "$gitconfig" ] && {
        echo -ne "${echo_yellow}Want to install the modified git config file? [y/N] ${echo_normal}"
        read -n 1 reply
        case "$reply" in
            Y|y)
                echo
                [ -w "$gitconfig" ] && cp "$gitconfig" "$gitconfig.bak" &&
                    echo -e "${echo_cyan}Your $(basename "$gitconfig") has been backed up to $gitconfig.bak ${echo_normal}"
                ;;
        esac
    }
    cp "$CB_BASE/templates/gitconfig.template" "$gitconfig"

    _update_git_user_name
    _update_git_user_email
    _update_git_platform_mods

    echo -e "${echo_cyan}CarryBag modifications have been applied to $gitconfig${echo_normal}"
    #git config --list
}

_build_carrybag_git_ignore () {

    local gitignore=~/.gitignore

    [ -w "$gitignore" ] && cp "$gitignore" "$gitignore.bak" &&
        echo -e "${echo_cyan}Your $(basename "$gitignore") has been backed up to $gitignore.bak ${echo_normal}"

    cp "$CB_BASE/templates/gitignore.template" "$gitignore"

    ## Global ignore file
    git config --global core.excludesfile "$HOME/.gitignore"
}
