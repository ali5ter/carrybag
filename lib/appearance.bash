#!/usr/bin/env bash

set -e

source lib/solarized_terminal.bash

install_solarized_Xresources
echo -e "${echo_cyan}Solarized Dark was installed as your X Windows color theme.${echo_normal}"

[[ $OSTYPE == darwin* ]] && {
    echo -ne "${echo_yellow}Want to install Solarized Dark as your default OSX Terminal settings profile? [y/N] ${echo_normal}"
    read -n 1 reply
    case "$reply" in
        Y|y)
            install_solarized_dark_osx_terminal
            echo -e "\n${echo_cyan}Solarized Dark was made your default OSX Terminal settings profile.${echo_normal}"
            ;;
        N|n)    echo ;;
    esac
}
