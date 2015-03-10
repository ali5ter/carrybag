# Carrybag library functions for nativescript configuration

_cblib_nativescript=1

build_carrybag_nativescript_config () {

    case "$OSTYPE" in
        darwin*)    install_nativescript_osx ;;
        *)          install_nativescript_linux ;;
    esac
    return 0
}

install_nativescript_osx () {
    ## @see http://docs.nativescript.org/setup/ns-cli-setup/ns-setup-os-x.html

    command -v xcrun >/dev/null || {
        echo -e "${echo_yellow}Install Xcode from https://developer.apple.com/downloads/index.action.${echo_normal}"
        return 1
    }

    command -v mono >/dev/null || {
        echo -ne "${echo_cyan}Installing mono${echo_normal}"
        brew install mono
    }

    [ -z "$cblib_android" ] && source cblib_android.bash
    build_carrybag_android_config

    install_node_module nativescript
    # sourcep

    return 0
}

install_nativescript_linux () {
    # @see http://docs.nativescript.org/setup/ns-cli-setup/ns-setup-linux.html

    return 0
}
