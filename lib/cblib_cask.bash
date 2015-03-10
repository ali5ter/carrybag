# Carrybag library functions for cask configuration

_cblib_cask=1

install_cask () {

    command -v brew >/dev/null || {
        [ -z "$cblib_homebrew" ] && source cblib_homebrew.bash
        build_carrybag_homebrew_config
    }

    brew install caskroom/cask/brew-cask
    return 0
}

install_cask_app () {

    local cask=$1
    local _cask=''
    local split="$(echo "$cask" | sed -e 's/-/ /g')"
    for word in $split; do
        word="${word^}"
        _cask="$_cask $word"
    done
    _cask="${_cask/ /}"
    local appdir="${2:-$_cask}"

    ls -d /Applications/"$appdir"* >/dev/null 2>&1 || \
        brew cask install --appdir=/Applications "$cask"
    return 0
}

update_cask () {

    brew update && \
    brew upgrade brew-cask && \
    brew cleanup && \
    brew cask cleanup
    return 0
}

build_carrybag_cask_config () {

    brew cask 2>&1 | grep "Error: Unknown command: cask" >/dev/null && {
        echo -e "${echo_cyan}Installing cask.${echo_normal}"
        install_cask
    }

    echo -e "${echo_cyan}Installing cask packages.${echo_normal}"
    ## @see http://caskroom.io/search
    #install_cask_app 1password 1Password\ 5
    #install_cask_app skype
    #install_cask_app cinch     # simple window manager
    #install_cask_app caffeine  # no sleep
    #install_cask_app mou       # live markdown editor
    #install_cask_app sourcetree
    #install_cask_app sophos-anti-virus-home-edition
    return 0
}
