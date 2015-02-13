#!/usr/bin/env bash
# Install CarryBag

set -e

export CB_BASE=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )
export BASH_IT=~/.bash_it

clear

## Load convenience functions for color
source "$CB_BASE/3rdparty/bash-it/themes/colors.theme.bash"

## Check we got git
hash git >/dev/null 2>&1 || {
    echo -e "${echo_orange}Unable to find git.${echo_normal} Please install it and try installing again."
    exit
}

## Fetch 3rd party packages
echo -e "${echo_cyan}Fetching/updating 3rd party packages.$echo_normal"
git submodule update --init --recursive

## Move Bash it into place
[ -d "$BASH_IT" ] && rm -fR "$BASH_IT"
cp -r "$CB_BASE/3rdparty/bash-it" "$BASH_IT"

## CarryBag includes
source "$CB_BASE/lib/helpers.bash"
source "$CB_BASE/lib/appearance.bash"
[[ $OSTYPE == darwin* ]] && source "$CB_BASE/lib/homebrew.bash"
source "$CB_BASE/lib/node.bash"
source "$CB_BASE/lib/ruby.bash"
source "$CB_BASE/lib/vim.bash"

## CarryBag modifications
_build_carrybag_bash_runcom
[[ $OSTYPE == darwin* ]] && _build_carrybag_homebrew_config
_build_carrybag_node_config
_build_carrybag_vim_config
_preload_carrybag_addons
_preload_carrybag_themes

## Preserve path to this dir
_add_to_bash_runcom "export CB_BASE=\"$CB_BASE\""

## Load Bash it libs to help enable addons
source "${BASH_IT}/lib/composure.sh"
cite _about _param _example _group _author _version
for file in ${BASH_IT}/lib/*.bash; do source "$file"; done

## Enable addons that come with Bash it
echo -e "${echo_cyan}Pre-loading Bash-it addons:$echo_normal"
_bash-it-enable alias general
_bash-it-enable alias git
_bash-it-enable alias homebrew
[[ $OSTYPE == darwin* ]] && _bash-it-enable alias osx
_bash-it-enable alias vim
_bash-it-enable completion bash-it
_bash-it-enable completion brew
_bash-it-enable completion defaults
_bash-it-enable completion git
_bash-it-enable completion ssh
_bash-it-enable plugin base
_bash-it-enable plugin dirs
_bash-it-enable plugin extract
_bash-it-enable plugin git
[[ $OSTYPE == darwin* ]] && _bash-it-enable plugin osx
_bash-it-enable plugin ssh

## Enable addons that come with CarryBag
_bash-it-enable completion jump
_bash-it-enable plugin carrybag-general
_bash-it-enable plugin jump

echo -e "$echo_yellow"' _______ _______ ______   ______   __   __ _______ _______ _______ '"$echo_normal"
echo -e "$echo_yellow"'|       |   _   |    _ | |    _ | |  | |  |  _    |   _   |       |'"$echo_normal"
echo -e "$echo_yellow"'|       |  |_|  |   | || |   | || |  |_|  | |_|   |  |_|  |    ___|'"$echo_normal"
echo -e "$echo_yellow"'|       |       |   |_||_|   |_||_|       |       |       |   | __ '"$echo_normal"
echo -e "$echo_yellow"'|      _|       |    __  |    __  |_     _|  _   ||       |   ||  |'"$echo_normal"
echo -e "$echo_yellow"'|     |_|   _   |   |  | |   |  | | |   | | |_|   |   _   |   |_| |'"$echo_normal"
echo -e "$echo_yellow"'|_______|__| |__|___|  |_|___|  |_| |___| |_______|__| |__|_______|'"$echo_normal"
echo -e "$echo_green"'                                                   ...is installed!'"$echo_normal"

echo -e "${echo_cyan}Start a new shell or, if you are re-installing CarryBag, run ${echo_white}reload${echo_cyan} to source any updates.$echo_normal"
echo -e "${echo_cyan}Use ${echo_white}bash-it show [aliases|completions|plugins]${echo_cyan} to manage functionality.$echo_normal"
