# CarryBag library functions for nodejs and npm

_cblib_node=1

build_carrybag_node_config () {

    case "$OSTYPE" in
        darwin*)    build_carrybag_node_configuration_osx ;;
        *)          build_carrybag_node_configuration_linux ;;
    esac
    return 0
}

install_node_using_brew () {

    brew install node
    return 0
}

install_node_using_apt () {

    ## Going to assume latest ubuntu version, xenial (16.04)
    if [ "$(lsb_release -cs)" == "xenial" ]; then
        curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
    else
        echo 'Upgrade to Ubuntu 16.04'
    fi
    sudo apt-get install -y nodejs
    sudo apt-get install -y build-essential
    sudo npm completion >> ~/.bashrc
    return 0
}

uninstall_node () {

    case "$OSTYPE" in
        darwin*)
            sudo rm -rf /usrlocal/lib/node_modules/npm
            brew uninstall node
            brew prune
            ;;
        *)
            sudo apt-get purge nodejs
            sudo apt-get autoremove
            ;;
    esac
    return 0
}

install_node_module () {

    local command=$1
    local pname=${2:-$command}

    command -v "$command" >/dev/null || npm install -g "$pname"
    return 0
}

update_node_modules () {

    ## Note that this also upgrades the node+npm environment too
    case "$OSTYPE" in
        darwin*)
            brew upgrade node
            npm install npm@latest -g
            npm update -g
            npm prune -g
            ;;
        *)

            sudo npm install npm@latest -g
            sudo npm update -g
            sudo npm prune -g
            ;;
    esac
    return 0
}

install_carrybag_node_packages () {

    install_node_module jshint
    install_node_module uglifyjs uglify-js
    ## Unable to build these on ubuntu 14.04 currently
    [[ $OSTYPE == darwin* ]] && {
        install_node_module wscat
        install_node_module node-inspector
    }
    install_node_module nodemon
    install_node_module http-server
    #install_node_module yo
    #install_node_module grunt grunt-cli
    install_node_module dt dokku-toolbelt
    install_node_module tsc typescript
    return 0
}

build_carrybag_node_configuration_osx () {

    if command -v node >/dev/null; then
        if ! $QUIET; then
            echo -ne "${echo_yellow}Want a clean install of node and npm? [y/N] ${echo_normal}"
            read -n 1 reply
            case "$reply" in
                Y|y) echo; uninstall_node && install_node_using_brew ;;
            esac
        fi
    else
        echo -e "${echo_cyan}Installing node and npm.${echo_normal}"
        install_node_using_brew
    fi

    add_to_bash_runcom "export PATH=\"\$HOME/.node/bin:\$PATH\"\\
export NODE_PATH=\"/usr/local/lib/node_modules:\$NODE_PATH\""

    export PATH="$HOME/.node/bin:$PATH"
    export NODE_PATH="/usr/local/lib/node_modules:$NODE_PATH"

    echo -e "${echo_cyan}Installing node packages.${echo_normal}"
    install_carrybag_node_packages

    return 0
}

build_carrybag_node_configuration_linux () {

    if command -v node >/dev/null; then
        if ! $QUIET; then
            echo -ne "${echo_yellow}Want a clean install of node and npm? [y/N] ${echo_normal}"
            read -n 1 reply
            case "$reply" in
                Y|y)    echo; uninstall_node && install_node_using_apt ;;
            esac
        fi
    else
        echo -e "${echo_cyan}Installing node and npm.${echo_normal}"
        install_node_using_apt
    fi

    echo -e "${echo_cyan}Installing node packages.${echo_normal}"
    install_carrybag_node_packages

    return 0
}
