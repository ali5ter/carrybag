#!/usr/bin/env bash
# Install CarryBag

set -e

BASE=$(cd "$(dirname "$0")" && pwd)
BASH_IT=~/.bash_it

## Check we got git
hash git >/dev/null 2>&1 || {
    echo -e "\033[0;33mG\Unable to find git.\033[0m Please install it and try installing again"
    exit
}

## Install Bash it
[ -e $BASH_IT ] && rm -f $BASH_IT
ln -sf $BASE/3rdparty/bash-it $BASH_IT
case $OSTYPE in
    darwin*)    BASHRC=~/.bash_profile ;;
    *)          BASHRC=~/.bashrc ;;
esac
[ -w $BASHRC ] && cp $BASHRC $BASHRC.bak
cp $BASH_IT/template/bash_profile.template.bash $BASHRC

## Customize default Bash it runcom
sed -e s/bobby/alister/ $BASHRC > $BASHRC.tmp && mv $BASHRC.tmp $BASHRC
sed -e s/git@git.domain.com/git@gitlab.different.com/ $BASHRC > $BASHRC.tmp && mv $BASHRC.tmp $BASHRC
sed -e s/\\/usr\\/bin\\/mate\ -w/vim/g $BASHRC > $BASHRC.tmp && mv $BASHRC.tmp $BASHRC

## Load Bash it aliases, completions and plugins
source $BASH_IT/bash_it.sh
bash-it enable alias general
bash-it enable alias git
bash-it enable alias homebrew
[ "$OSTYPE" == "darwin*" ] && bash-it enable alias osx
bash-it enable alias vim
bash-it enable completion bash-it
bash-it enable completion brew
bash-it enable completion defaults
bash-it enable completion git
bash-it enable completion ssh
bash-it enable plugin base
bash-it enable plugin dirs
bash-it enable plugin extract
bash-it enable plugin git
bash-it enable plugin git
bash-it enable plugin history
[ "$OSTYPE" == "darwin*" ] && bash-it enable plugin osx
bash-it enable plugin ssh

## Initialize CarryBag
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
