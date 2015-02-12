#!/usr/bin/env bash
# node.js configuation delivered by CarryBag

set -e

_build_carrybag_node_config () {

    case "$OSTYPE" in
        darwin*)    _build_carrybag_node_configuration_osx ;;
        *)          _build_carrybag_node_configuration_linux ;;
    esac
}

_install_node_using_brew () {

    ## @see https://gist.github.com/DanHerbert/9520689
    brew install node --without-npm
    echo prefix=~/.node >> ~/.npmrc
    curl -L https://www.npmjs.org/install.sh | sh
    export PATH="$HOME/.node/bin:$PATH"
    export NODE_PATH="/usr/local/lib/node_modules/$NODE_PATH"
}

_uninstall_node () {

    case "$OSTYPE" in
        darwin*)
            for file in lib/node* include/node* bin/node share/man/man1/node.1 \
                    lib/dtrace/node.d ~/.node ~/.npm ~/.npmrc; do
                sudo rm -rf "/usr/local/$file"
            done
            brew ls --versions node && brew uninstall node
            ;;
        *)
            sudo apt-get -y remove nodejs
            ;;
    esac
}

_install_node_pacakge () {

    local command=$1
    local pname=${1:-$command}
    command -v "$command" >/dev/null || sudo npm install -g "$pname"
}

_install_carrybag_node_packages () {

    _install_node_package jshint
    _install_node_package uglifyjs uglify-js
    _install_node_package node-inspector
    _install_node_package nodemon
    _install_node_package http-server
    _install_node_package ws
    #_install_node_package yo
    #_install_node_package grunt grunt-cli
}

_build_carrybag_node_configuration_osx () {

    if command -v node >/dev/null; then
        echo -ne "${echo_yellow}Want a clean install of node and npm? [y/N] ${echo_normal}"
        read -n 1 reply
        case "$reply" in
            Y|y)
                _uninstall_node
                _install_node_using_brew
                ;;
            N|n)    echo ;;
        esac
    else
        echo -e "${echo_cyan}Installing node and npm.${echo_normal}"
        _install_node_using_brew
    fi

    echo -e "${echo_cyan}Installing node packages.${echo_normal}"
    _install_carrybag_node_packages
}

_build_carrybag_node_configuration_linux () {

    command -v node >/dev/null || {
        echo -e "${echo_cyan}Installing of node and npm.${echo_normal}"
        sudo apt-get -y install python-software-properties python g++ make
        sudo add-apt-repository ppa:chris-lea/node.js
        sudo apt-get update
        sudo apt-get -y install nodejs
    }

    echo -e "${echo_cyan}Installing node packages.${echo_normal}"
    _install_carrybag_node_packages
}
