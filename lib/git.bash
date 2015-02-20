#!/usr/bin/env bash
# git configration delivered by CarryBag

set -e

_update_git_user_name () {

    local fullname="$(git config --get user.name)"

    [ -z "$fullname" ] && {
        case "$OSTYPE" in
            darwin*)    fullname="$(finger "$(whoami)" | awk -F: '{ print $3 }' | head -n1 | sed 's/^ //')" ;;
            *)          fullname="$USER" ;;
        esac
    }

    while true; do
        echo -ne "${echo_yellow}What name do you want attached to your git commits? [$fullname] ${echo_normal}"
        read reply
        case "$reply" in
            '') [ -n "$fullname" ] && break ;;
            *)  fullname="$reply"; break ;;
        esac
    done

    git config --global user.name "$fullname"
}

_update_git_user_email() {

    local email="$(git config --get user.email)"

    while true; do
        echo -ne "${echo_yellow}What email address do you want attached to your git commits? [$email] ${echo_normal}"
        read reply
        case "$reply" in
            '') [ -n "$email" ] && break ;;
            *)  email="$reply"; break ;;
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
    if [ -w "$gitconfig" ]; then
        echo -ne "${echo_yellow}Want to install a clean git config file? [y/N] ${echo_normal}"
        read -n 1 reply
        case "$reply" in
            Y|y)
                echo
                [ -w "$gitconfig" ] && cp "$gitconfig" "$gitconfig.bak" &&
                    echo -e "${echo_cyan}Your $(basename "$gitconfig") has been backed up to $gitconfig.bak ${echo_normal}"
                cp "$CB_BASE/templates/gitconfig.template" "$gitconfig"
                ;;
        esac
    else
        cp "$CB_BASE/templates/gitconfig.template" "$gitconfig"
    fi

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
