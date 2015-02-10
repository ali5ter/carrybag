#!/usr/bin/env bash

set -e

source lib/solarized_terminal.bash

install_solarized_Xresources
echo -e "${echo_cyan}Solarized Dark was installed as your X Windows color theme.$echo_normal"

[[ $OSTYPE == darwin* ]] && {
    install_solarized_dark_osx_terminal
    echo -e "${echo_cyan}Solarized Dark was made your default OSX Terminal settings profile.$echo_normal"
}
