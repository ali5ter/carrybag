# CarryBag library functions for appearance

_cblib_appearance=1

build_carryback_apperance () {

    [ -z "$_cblib_solarized" ] && source cblib_solarized.bash

    install_solarized_Xresources && \
        echo -e "${echo_cyan}Solarized Dark was installed as your X Windows color theme.${echo_normal}"

    case "$OSTYPE" in
        darwin*)
            [ -z "$_cblib_askuser" ] && source askuser.plugin.bash
            askuser cb_solarizedosx
            [ "$ASKUSER_REPLY" == 'y' ] && install_solarized_dark_osx_terminal &&
                echo -e "\n${echo_cyan}Solarized Dark was made your default OSX Terminal settings profile.${echo_normal}"
            ;;
        *)
            install_solarized_dark_gnome_terminal &&
                echo -e "\n${echo_cyan}Solarized Dark was made your default gnome terminal color profile.${echo_normal}"
            ;;
    esac
    return 0
}
