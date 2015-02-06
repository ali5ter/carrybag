#!/usr/bin/env bash

set -e

[[ $OSTYPE == darwin* ]] && {
    source lib/solarized_terminal.bash
    install_solarized_dark_osx_terminal
    echo -e "${echo_cyan}Solarized Dark was made your default OSX Terminal settings profile.$echo_normal"
}
