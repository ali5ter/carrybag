#!/usr/bin/env bash
# Install CarryBag

set -e

BASE=$(cd "$(dirname "$0")" && pwd)
BASH_IT=~/.bash_it

hash git >/dev/null 2>&1 || {
    echo -e "\033[0;33mG\Unable to find git.\033[0m Please install it and try installing again"
    exit
}

# Install Bash It framework
[ -e $BASH_IT ] && rm -f $BASH_IT
ln -sf $BASE/3rdparty/bash-it $BASH_IT
$BASH_IT/install.sh

# Initialize CarryBag
source $BASE/carrybag.sh
echo -e "\033[0;32m"' _______ _______ ______   ______   __   __ _______ _______ _______ '"\033[0m"
echo -e "\033[0;32m"'|       |   _   |    _ | |    _ | |  | |  |  _    |   _   |       |'"\033[0m"
echo -e "\033[0;32m"'|       |  |_|  |   | || |   | || |  |_|  | |_|   |  |_|  |    ___|'"\033[0m"
echo -e "\033[0;32m"'|       |       |   |_||_|   |_||_|       |       |       |   | __ '"\033[0m"
echo -e "\033[0;32m"'|      _|       |    __  |    __  |_     _|  _   ||       |   ||  |'"\033[0m"
echo -e "\033[0;32m"'|     |_|   _   |   |  | |   |  | | |   | | |_|   |   _   |   |_| |'"\033[0m"
echo -e "\033[0;32m"'|_______|__| |__|___|  |_|___|  |_| |___| |_______|__| |__|_______|'"\033[0m"
echo -e "\033[0;32m"'                  ....has spilled its contents all over your term!!'"\033[0m"
echo
