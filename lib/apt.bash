#!/usr/bin/env bash
# apt configuation delivered by CarryBag

set -e

_install_apt_package () {

    local command=$1
    local pname=${1:-$command}
    command -v "$command" >/dev/null || sudo apt-get -y install "$pname"
}

_update_apt_packages () {
    sudo apt-get -y update && \
    sudo apt-get -y upgrade && \
    sudo apt-get -y dist-upgrade && \
    sudo apt-get -y autoremove
}

_build_carrybag_apt_config () {

    command -v apt-get >/dev/null || {
        echo -e "${echo_orange}apt-get is not installed.${echo_normal}"
        return 1
    }

    echo -e "${echo_cyan}Installing apt packages.${echo_normal}"
    sudo apt-get -y install vim # force install of up to date version
    _install_apt_package curl
    _install_apt_package build-essential gcc
}
