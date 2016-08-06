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

    ## @see https://github.com/nodesource/distributions/issues/129
    if [ "$(lsb_release -cs)" == "wily" ]; then
        curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
    else
        curl -sL https://deb.nodesource.com/setup | sudo -E bash -
    fi
    sudo apt-get install -y nodejs
    sudo apt-get install -y build-essential
    # npm completion >> ~/.bashrc
    return 0
}

uninstall_node () {

    case "$OSTYPE" in
        darwin*)
            for file in /usr/local/lib/node \
                    /usr/local/lib/node_modules \
                    /usr/local/include/node \
                    /usr/local/include/node_modules \
                    /usr/local/bin/node \
                    /usr/local/bin/npm \
                    /usr/local/share/man/man1/node.1 \
                    /usr/local/lib/dtrace/node.d \
                    ~/.node ~/.npm \
                    ~/.npmrc; do
                sudo rm -fR "$file"
            done
            brew list -1 | grep -q node && brew uninstall node
            ;;
        *)
            npm ls -g --depth=0 | grep @ | cut -d' ' -f2 | cut -d'@' -f1 | \
                sudo xargs npm remove -g
            sudo apt-get -y remove nodejs npm
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

    npm update -g
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
