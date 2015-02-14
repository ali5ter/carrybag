#!/usr/bin/env bash
# homebrew configuation delivered by CarryBag

set -e

_install_homebrew () {

    ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go/install)"
}

_install_homebrew_package () {

    local command=$1
    local pname=${1:-$command}
    command -v "$command" >/dev/null || brew install "$pname"
}

_update_homebrew_packages () {
    brew update     # get homebrew up-to-date
    brew upgrade    # apply any updates
    brew cleanup    # clean up the crud
}

_build_carrybag_homebrew_config () {

    command -v brew >/dev/null || {
        echo -e "${echo_cyan}Installing homebrew.${echo_normal}"
        _install_homebrew
    }

    echo -e "${echo_cyan}Installing homebrew packages.${echo_normal}"
    _install_homebrew_package shellcheck
}
