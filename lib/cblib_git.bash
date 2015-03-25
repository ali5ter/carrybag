# CarryBag library functions for git configration

_cblib_git=1

update_git_user_name () {

    if ! $QUIET; then

        local fullname="$(git config --get user.name)"
        [ -z "$fullname" ] && {
            case "$OSTYPE" in
                darwin*)    fullname="$(finger "$(whoami)" | awk -F: '{ print $3 }' | head -n1 | sed 's/^ //')" ;;
                *)          fullname="$USER" ;;
            esac
        }

        askuser cb_gitfullname --default "$fullname"
        fullname="$ASKUSER_REPLY"
        git config --global user.name "$fullname"
    fi

    return 0
}

update_git_user_email() {

    if ! $QUIET; then

        local email="$(git config --get user.email)"

        askuser cb_gitemail --default "$email"
        email="$ASKUSER_REPLY"
        # TODO: Validate email address
        git config --global user.email "$email"
    fi

    return 0
}

update_git_platform_mods () {

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
            git config --global merge.tool meld
            git config --global mergetool.meld.cmd 'meld $BASE $LOCAL $REMOTE $MERGED'
            git config --global mergetool.meld.trustExitCode false
            git config --global diff.tool meld
            git config --global difftool.meld.cmd 'meld $LOCAL $REMOTE'
            ;;
    esac

    return 0
}

build_carrybag_git_config () {

    local gitconfig=~/.gitconfig

    ## Create a basic gitconfig file
    if [ -w "$gitconfig" ]; then
        if ! $QUIET; then
            askuser cb_gitclean
            [ "$ASKUSER_REPLY" == 'y' ] && {
                echo
                [ -w "$gitconfig" ] && cp "$gitconfig" "$gitconfig.bak" &&
                    echo -e "${echo_cyan}Your $(basename "$gitconfig") has been backed up to $gitconfig.bak ${echo_normal}"
                cp "$CB_BASE/templates/gitconfig.template" "$gitconfig"
            }
        fi
    else
        cp "$CB_BASE/templates/gitconfig.template" "$gitconfig"
    fi

    update_git_user_name
    update_git_user_email
    update_git_platform_mods

    echo -e "${echo_cyan}CarryBag modifications have been applied to $gitconfig${echo_normal}"
    #git config --list

    return 0
}

build_carrybag_git_ignore () {

    local gitignore=~/.gitignore

    [ -w "$gitignore" ] && cp "$gitignore" "$gitignore.bak" &&
        echo -e "${echo_cyan}Your $(basename "$gitignore") has been backed up to $gitignore.bak ${echo_normal}"

    cp "$CB_BASE/templates/gitignore.template" "$gitignore"

    ## Global ignore file
    git config --global core.excludesfile "$HOME/.gitignore"

    return 0
}
