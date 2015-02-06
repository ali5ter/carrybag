#!/usr/bin/env bash
# Install CarryBag

set -e

BASE=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )
BASH_IT=~/.bash_it

## Check we got git
hash git >/dev/null 2>&1 || {
    echo -e "${echo_orange}Unable to find git.${echo_normal} Please install it and try installing again"
    exit
}

## Fetch 3rd party packages
git submodule init && git submodule update

## Load colors for convenience
source "$BASE/3rdparty/bash-it/themes/colors.theme.bash"

## Start the initialization...
echo -e "$echo_yellow"' _______ _______ ______   ______   __   __ _______ _______ _______ '"$echo_normal"
echo -e "$echo_yellow"'|       |   _   |    _ | |    _ | |  | |  |  _    |   _   |       |'"$echo_normal"
echo -e "$echo_yellow"'|       |  |_|  |   | || |   | || |  |_|  | |_|   |  |_|  |    ___|'"$echo_normal"
echo -e "$echo_yellow"'|       |       |   |_||_|   |_||_|       |       |       |   | __ '"$echo_normal"
echo -e "$echo_yellow"'|      _|       |    __  |    __  |_     _|  _   ||       |   ||  |'"$echo_normal"
echo -e "$echo_yellow"'|     |_|   _   |   |  | |   |  | | |   | | |_|   |   _   |   |_| |'"$echo_normal"
echo -e "$echo_yellow"'|_______|__| |__|___|  |_|___|  |_| |___| |_______|__| |__|_______|'"$echo_normal"
echo -e "$echo_green"'                                                ....is installing'"$echo_normal"
echo

## Install Bash it
[ -e "$BASH_IT" ] && rm -f "$BASH_IT"
ln -sf "$BASE/3rdparty/bash-it" "$BASH_IT"

## Replace runcom with a customized version from Bash it
case "$OSTYPE" in
    darwin*)    BASHRC=~/.bash_profile ;;
    *)          BASHRC=~/.bashrc ;;
esac
[ -w "$BASHRC" ] && cp "$BASHRC" "$BASHRC.bak" &&
    echo -e "${echo_cyan}Your $BASHRC has been backed up to $BASHRC.bak$echo_normal"
cp "$BASH_IT/template/bash_profile.template.bash" "$BASHRC"

## Customize default Bash it runcom
sed -e s/bobby/alister/ "$BASHRC" > "$BASHRC.tmp" && mv "$BASHRC.tmp" "$BASHRC"
sed -e s/git@git.domain.com/git@gitlab.different.com/ "$BASHRC" > "$BASHRC.tmp" && mv "$BASHRC.tmp" "$BASHRC"
sed -e s/\\/usr\\/bin\\/mate\ -w/vim/g "$BASHRC" > "$BASHRC.tmp" && mv "$BASHRC.tmp" "$BASHRC"

set -x
## Initialize the term appearance
[[ $OSTYPE == darwin* ]] && $(lib/solarized_osx_terminal.bash) &&
    echo -e "${echo_cyan}Solarized Dark was made your default OSX Terminal settings profile$echo_normal"
ln -sf "$BASE/themes/alister" "$BASH_IT/themes/alister"
exit 0

## Start the initialization...
## Load Bash it aliases, completions and plugins
source "$BASH_IT/bash_it.sh"
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

source "$BASHRC"
