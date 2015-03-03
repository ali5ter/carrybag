# CarryBag library functions for appearance

_cblib_appearance=1

build_carryback_apperance () {

    [ -z "$_cblib_solarized" ] && source solarized.bash

    install_solarized_Xresources && \
        echo -e "${echo_cyan}Solarized Dark was installed as your X Windows color theme.${echo_normal}"

    case "$OSTYPE" in
        darwin*)
            if ! $QUIET; then
                echo -ne "${echo_yellow}Want to install Solarized Dark as your default OSX Terminal settings profile? [y/N] ${echo_normal}"
                read -n 1 reply
                case "$reply" in
                    Y|y)
                        install_solarized_dark_osx_terminal &&
                            echo -e "\n${echo_cyan}Solarized Dark was made your default OSX Terminal settings profile.${echo_normal}"
                esac
            fi
            ;;
        *)
            install_solarized_dark_gnome_terminal &&
                echo -e "\n${echo_cyan}Solarized Dark was made your default gnome terminal color profile.${echo_normal}"
            ;;
    esac

    return 0
}
