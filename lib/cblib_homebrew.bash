# CarryBag library functions for the homebrew package manager

_cblib_homebrew=1

install_homebrew () {

    ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go/install)"
    return 0
}

install_homebrew_package () {

    local command=$1
    local pname=${1:-$command}

    command -v "$command" >/dev/null || brew install "$pname"
    return 0
}

update_homebrew_packages () {

    brew update     # get homebrew up-to-date
    brew upgrade    # apply any updates
    brew cleanup    # clean up the crud
    return 0
}

build_carrybag_homebrew_config () {

    command -v brew >/dev/null || {
        echo -e "${echo_cyan}Installing homebrew.${echo_normal}"
        install_homebrew
    }

    echo -e "${echo_cyan}Installing homebrew packages.${echo_normal}"
    brew install vim    # force install a more up to date vim
    brew install ctags  # force install exuberant-ctags
    install_homebrew_package shellcheck
    return 0
}
