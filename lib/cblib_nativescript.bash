# Carrybag library functions for nativescript configuration

_cblib_nativescript=1

build_carrybag_nativescript_configuration () {

    case "$OSTYPE" in
        darwin*)    install_nativescript_osx ;;
        *)          install_nativescript_linux ;;
    esac

    return 0
}

install_nativescript_osx () {
    ## @see http://docs.nativescript.org/setup/ns-cli-setup/ns-setup-os-x.html

    command -v brew >/dev/null || {
        [ -z "$cblib_homebrew" ] && source cblib_homebrew.bash
        build_carrybag_homebrew_config
    }

    [ -z "$cblib_node" ] && source cblib_node.bash
    command -v node >/dev/null || {
        build_carrybag_node_config
    }

    command -v xcrun >/dev/null || {
        echo -e "${echo_yellow}Install Xcode from https://developer.apple.com/downloads/index.action.${echo_normal}"
        return 1
    }

    command -v mono >/dev/null || {
        echo -ne "${echo_cyan}Installing mono${echo_normal}"
        brew install mono
    }

    javac -version 2>&1 | grep 1.7 >/dev/null || {
        echo -e "${echo_yellow}Install JDK 7 from http://www.oracle.com/technetwork/java/javase/downloads/index.html.${echo_normal}"
        return 1
    }

    command -v ant >/dev/null || {
        echo -e "${echo_cyan}Installing ant${echo_normal}"
        brew install ant
    }

    command -v android >/dev/null || {
        echo -e "${echo_cyan}Installing android-sdk${echo_normal}"
        brew install android-sdk
    }
        PATH="${PATH}:/Applications/Android Studio.app/sdk/tools:/Applications/Android Studio.app/sdk/platform-tools"

    echo -ne "${echo_yellow}Want to update Android packages? [y/N] ${echo_normal}"
    read -n 1 reply
    case "$reply" in
        Y|y)
            echo -e "${echo_cyan}\nSelect all packages for the Android 19 SDK and any other SDKs that you want to install and click Install${echo_normal}"
            android update sdk ;;
    esac

    [ -e /Applications/Genymotion.app ] || {
        echo -e "${echo_yellow}Install Genymotion, a faster Anroid emulator that runing on VirtualBox:${echo_normal}"
        echo -e "${echo_yellow}1. Download VirtualBox from https://www.virtualbox.org/wiki/Downloads and install VirtualBox for OSX.${echo_normal}"
        echo -e "${echo_yellow}2. Download Genymotion from https://www.genymotion.com/#!/download, select Mac and 'Get Genymotion'.${echo_normal}"
        return 1
    }
    PATH="$PATH:/Applications/Genymotion\ Shell.app/Contents/MacOS/:/Applications/Genymotion.app/Contents/MacOS/"

    install_node_module nativescript
    # sourcep

    return 0
}

install_nativescript_linux () {
    # @see http://docs.nativescript.org/setup/ns-cli-setup/ns-setup-linux.html

    return 0
}
