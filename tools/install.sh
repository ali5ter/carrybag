#!/usr/bin/env bash
# Install CarryBag

set -e

export CB_BASE=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )
export BASH_IT=~/.bash_it

## Check we got git
hash git >/dev/null 2>&1 || {
    echo -e "${echo_orange}Unable to find git.${echo_normal} Please install it and try installing again."
    exit
}

## Fetch 3rd party packages
git submodule init && git submodule update

## Load convenience functions for color
source "$CB_BASE/3rdparty/bash-it/themes/colors.theme.bash"

## Start the initialization...
echo -e "$echo_yellow"' _______ _______ ______   ______   __   __ _______ _______ _______ '"$echo_normal"
echo -e "$echo_yellow"'|       |   _   |    _ | |    _ | |  | |  |  _    |   _   |       |'"$echo_normal"
echo -e "$echo_yellow"'|       |  |_|  |   | || |   | || |  |_|  | |_|   |  |_|  |    ___|'"$echo_normal"
echo -e "$echo_yellow"'|       |       |   |_||_|   |_||_|       |       |       |   | __ '"$echo_normal"
echo -e "$echo_yellow"'|      _|       |    __  |    __  |_     _|  _   ||       |   ||  |'"$echo_normal"
echo -e "$echo_yellow"'|     |_|   _   |   |  | |   |  | | |   | | |_|   |   _   |   |_| |'"$echo_normal"
echo -e "$echo_yellow"'|_______|__| |__|___|  |_|___|  |_| |___| |_______|__| |__|_______|'"$echo_normal"
echo -e "$echo_green"'is installing...'"$echo_normal"

## Includes
source "$CB_BASE/lib/helpers.bash"
source "$CB_BASE/lib/appearance.bash"

## Move Bash it into place
[ -d "$BASH_IT" ] && rm -fR "$BASH_IT"
cp -r "$CB_BASE/3rdparty/bash-it" "$BASH_IT"

## Enable CarryBag modifications
_build_carrybag_bash_runcom
_preload_carrybag_additions

## Load Bash it libs to help enable additions
source "${BASH_IT}/lib/composure.sh"
cite _about _param _example _group _author _version
for file in ${BASH_IT}/lib/*.bash; do source $file; done

## Enable additions that come with Bash it
bash-it enable alias general
bash-it enable alias git
bash-it enable alias homebrew
[[ $OSTYPE == darwin* ]] && bash-it enable alias osx
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
[[ $OSTYPE == darwin* ]] && bash-it enable plugin osx
bash-it enable plugin ssh

## Enable additions that come with CarryBag
bash-it enable alias findability
bash-it enable completion jump
bash-it enable plugin jump

echo -e "${echo_cyan}Installation complete! Start a new terminal to use CarryBag.$echo_normal"
echo -e "${echo_cyan}In this new terminal use ${echo_white}bash-it show [aliases|completions|plugins]${echo_cyan} to manage functionality.$echo_normal"
