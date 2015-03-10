# Carrybag library functions for android configuration

_cblib_android=1

build_carrybag_android_config () {

    case "$OSTYPE" in
        darwin*)    install_android_osx ;;
        *)          install_android_linux ;;
    esac
    return 0
}

uninstall_adt () {

    case "$OSTYPE" in
        darwin*)
            ## Android SDK
            brew uninstall android-sdk
            rm -fR ~/Library/Android*
            ## Android Developer Tools
            sudo rm -fR /Applications/ADT*
            ## Android Studio
            rm -fR ~/.android
            rm -fR ~/.gradle
            rm -fR ~/AndroidstudioProjects
            rm -fR ~/Library/Preferences/AndroidStudio*
            rm ~/Library/Preferences/com.google.android.studio.plist
            rm -fR ~/Library/Application\ Support/AndroidStudio*
            rm -fR ~/Library/Logs/AndroidStudio*
            rm -fR ~/Library/Caches/AndroidStudio*
            rm -fR /Applications/Android\ Studio.app
            ;;
        *)
            ;;
    esac
    return 0
}

install_android_osx () {
    ## @see http://docs.nativescript.org/setup/ns-cli-setup/ns-setup-os-x.html

    [ -z "$cblib_runcom" ] && source cblib_runcom.bash
    [ -z "$cblib_cask" ] && source cblib_cask.bash

    build_carrybag_cask_config

    install_cask_app java
    brew install ant
    brew install android-sdk
    install_cask_app android-studio

    local _path="$(command -v android)"
    local _link="$(readlink "$_path")"
    local _relpath="$(dirname "$_path")/$(dirname "$_link")"
    cd "$_relpath"
    local _abspath="$(PWD -P)"
    cd - >/dev/null
    add_to_bash_runcom "export PATH=\"\$PATH:$_abspath/tools:$_abspath/platform-tools\""

    echo -ne "${echo_yellow}Want to update Android packages? [y/N] ${echo_normal}"
    read -n 1 reply
    case "$reply" in
        Y|y)
            echo -e "${echo_cyan}\nSelect all packages for installation and click Install${echo_normal}"
            android update sdk ;;
    esac

    install_cask_app intel-haxm
    install_cask_app virtualbox
    install_cask_app genymotion

    add_to_bash_runcom "export PATH=\"\$PATH:/Applications/Genymotion\ Shell.app/Contents/MacOS/:/Applications/Genymotion.app/Contents/MacOS/\""
    return 0
}

install_android_linux () {
    # @see http://docs.nativescript.org/setup/ns-cli-setup/ns-setup-linux.html

    return 0
}
