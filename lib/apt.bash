#!/usr/bin/env bash
# apt configuation delivered by CarryBag

set -e

_install_apt_package () {

    local command=$1
    local pname=${1:-$command}
    command -v "$command" >/dev/null || sudo apt-get install -y "$pname"
}

_update_apt_packages () {
    sudo apt-get update -y && \
    sudo apt-get upgrade -y && \
    sudo apt-get dist-upgrade -y
}

_build_carrybag_apt_config () {

    command -v apt-get >/dev/null || {
        echo -e "${echo_orange}apt-get is not installed.${echo_normal}"
        return 1
    }

    echo -e "${echo_cyan}Installing apt packages.${echo_normal}"
    sudo apt-get install -y vim # force install of up to date version
    _install_apt_package curl
    _install_apt_package build-essential gcc
}
