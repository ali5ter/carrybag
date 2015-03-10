# CarryBag library functions for the homebrew package manager

_cblib_homebrew=1

install_homebrew () {

    ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go/install)"
    return 0
}

install_homebrew_package () {

    local command=$1
    local pname=${2:-$command}

    command -v "$command" >/dev/null || brew install "$pname"
    return 0
}

update_homebrew_packages () {

    brew update && \
    brew upgrade && \
    brew cleanup
    return 0
}

build_carrybag_homebrew_config () {

    command -v brew >/dev/null || {
        echo -e "${echo_cyan}Installing homebrew.${echo_normal}"
        install_homebrew
    }

    echo -e "${echo_cyan}Installing homebrew packages.${echo_normal}"

    brew install bash   # force install of an up to date bash shell
    [ "$SHELL" == "/usr/local/bin/bash" ] || chsh -s /usr/local/bin/bash

    brew install vim    # force install of an up to date vim
    brew install ctags  # force install exuberant-ctags
    install_homebrew_package shellcheck
    return 0
}
