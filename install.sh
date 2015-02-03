#!/usr/bin/env bash
# Install CarryBag

set -e

BASE=$(cd "$(dirname "$0")" && pwd)
CB=~/.carrybag

[ -d "$CB" ] && {
    echo -e "\033[0;33mCarryBag appears to be installed.\033[0m Please remove $CB and try installing again"
    exit
}

hash git >/dev/null 2>&1 || {
    echo -e "\033[0;33mG\Unable to find git.\033[0m Please install it and try installing again"
    exit
}

# If install script downloaded in isolation from the repo, clone the repo
[ "$(git remote show origin | grep -m 1 -c carrybag.git)" == "0" ] && {
    echo -e "\033[0;34mCloning CarryBag...\033[0m"
    git clone http://gitlab.different.com/alister/carrybag.git $CB
}

# Sym-link cloned repo to correct location
[ "$BASE" != "$CB" ] && ln -sf $BASE $CB

# Set up the runcom file
case "$OSTYPE" in
    darwin*)    BASHRC=~/.bash_profile;;
    *)          BASHRC=~/.bashrc;;
esac
[ -w "$BASHRC" ] && {
    cp "$BASHRC" "$BASHRC.bak"
    echo -e "\033[0;34mYour $BASHRC has been copied to $BASHRC.bak\033[0m"
}
echo -e "\033[0;34mCopying the CarryBag runcom template to $BASHRC\033[0m"
cp $CB/templates/bashrc.template.bash $BASHRC

# Initialize CarryBag
echo -e "\033[0;32m"' _______ _______ ______   ______   __   __ _______ _______ _______ '"\033[0m"
echo -e "\033[0;32m"'|       |   _   |    _ | |    _ | |  | |  |  _    |   _   |       |'"\033[0m"
echo -e "\033[0;32m"'|       |  |_|  |   | || |   | || |  |_|  | |_|   |  |_|  |    ___|'"\033[0m"
echo -e "\033[0;32m"'|       |       |   |_||_|   |_||_|       |       |       |   | __ '"\033[0m"
echo -e "\033[0;32m"'|      _|       |    __  |    __  |_     _|  _   ||       |   ||  |'"\033[0m"
echo -e "\033[0;32m"'|     |_|   _   |   |  | |   |  | | |   | | |_|   |   _   |   |_| |'"\033[0m"
echo -e "\033[0;32m"'|_______|__| |__|___|  |_|___|  |_| |___| |_______|__| |__|_______|'"\033[0m"
echo -e "\033[0;32m"'                  ....has spilled its contents all over your term!!'"\033[0m"
echo -e "\033[0;32m"'No matter! You can always rearrange these using the carrybag command.'"\033[0m"
source "$BASHRC"
