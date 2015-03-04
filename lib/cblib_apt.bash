# Carrybag library function for the apt package manager

_cblib_apt=1

install_apt_package () {

    local command=$1
    local pname=${1:-$command}
    command -v "$command" >/dev/null || sudo apt-get install -y "$pname"
    return 0
}

update_apt_packages () {

    sudo apt-get update -y && \
    sudo apt-get upgrade -y && \
    sudo apt-get dist-upgrade -y
    return 0
}

build_carrybag_apt_config () {

    command -v apt-get >/dev/null || {
        echo -e "${echo_orange}apt-get is not installed.${echo_normal}"
        return 1
    }

    echo -e "${echo_cyan}Installing apt packages.${echo_normal}"
    sudo apt-get install -y vim # force install of up to date version
    install_apt_package curl
    install_apt_package build-essential gcc
    install_apt_package meld
    install_apt_package exuberant-ctags ctags
    return 0
}
