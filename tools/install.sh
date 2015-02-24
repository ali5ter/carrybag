#!/usr/bin/env bash
# Install CarryBag

set -e

export CB_BASE=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )
export BASH_IT=~/.bash_it

clear

## Check we got git
hash git >/dev/null 2>&1 || {
    echo -e "\033[0;33mUnable to find git.\033[0m Please install it and try installing again."
    exit
}

## Fetch 3rd party packages
echo -ne "\033[0;33mWant to fetch the 3rd party packagese? [y/N] \033[0m"
read -n 1 reply
case "$reply" in
    Y|y)
        echo -e "\n\033[0;36mFetching/updating 3rd party packages.\033[0m"
        git submodule update --init --recursive ## updated to the commit recorded by the submodule reference
esac

## Load convenience functions for color
source "$CB_BASE/3rdparty/bash-it/themes/colors.theme.bash"

## Move Bash it into place
[ -d "$BASH_IT" ] && rm -fR "$BASH_IT"
cp -r "$CB_BASE/3rdparty/bash-it" "$BASH_IT"

## CarryBag includes
source "$CB_BASE/lib/helpers.bash"
source "$CB_BASE/lib/appearance.bash"
source "$CB_BASE/lib/runcom.bash"
source "$CB_BASE/lib/git.bash"
case "$OSTYPE" in
    darwin*)   source "$CB_BASE/lib/homebrew.bash" ;;
    *)         source "$CB_BASE/lib/apt.bash" ;;
esac
source "$CB_BASE/lib/node.bash"
source "$CB_BASE/lib/ruby.bash"
source "$CB_BASE/lib/vim.bash"

## CarryBag modifications
_build_carrybag_bash_runcom
_build_carrybag_git_config
_build_carrybag_git_ignore
case "$OSTYPE" in
    darwin*)   _build_carrybag_homebrew_config ;;
    *)         _build_carrybag_apt_config ;;
esac
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

## Enable addons that come with Bash it & CarryBag
echo -e "${echo_cyan}Pre-loading addons:$echo_normal"
_bash-it-enable alias general
_bash-it-enable alias carrybag-general
_bash-it-enable alias git
_bash-it-enable alias vim
_bash-it-enable completion bash-it
_bash-it-enable completion defaults
_bash-it-enable completion git
_bash-it-enable completion jump
_bash-it-enable completion ssh
_bash-it-enable plugin base
_bash-it-enable plugin carrybag-general
_bash-it-enable plugin dirs
_bash-it-enable plugin extract
_bash-it-enable plugin git
_bash-it-enable plugin jump
_bash-it-enable plugin ssh
_bash-it-enable plugin zzz-carrybag-overrides
case "$OSTYPE" in
    darwin*)
        _bash-it-enable alias homebrew
        _bash-it-enable alias osx
        _bash-it-enable completion brew
        _bash-it-enable plugin carrybag-osx
        _bash-it-enable plugin osx
        ;;
    *)
        _bash-it-enable plugin carrybag-linux
        ;;
esac

## Prepopulate jump bookmarks
jbookmarks=~/.jump/bookmarks
if [ -f "$jbookmarks" ]; then
    grep carrybag "$jbookmarks" >/dev/null || \
        echo "carrybag::$CB_BASE" >> "$jbookmarks"
else
    [ -d "$(dirname "$jbookmarks")" ] || mkdir "$(dirname "$jbookmarks")"
    echo "carrybag::$CB_BASE" > "$jbookmarks"
fi

clear
echo
echo -e "$echo_yellow"'  ██████╗ █████╗ ██████╗ ██████╗ ██╗   ██╗██████╗  █████╗  ██████╗ '"$echo_normal"
echo -e "$echo_green"' ██╔════╝██╔══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝██╔══██╗██╔══██╗██╔════╝ '"$echo_normal"
echo -e "$echo_yellow"' ██║     ███████║██████╔╝██████╔╝ ╚████╔╝ ██████╔╝███████║██║  ███╗'"$echo_normal"
echo -e "$echo_green"' ██║     ██╔══██║██╔══██╗██╔══██╗  ╚██╔╝  ██╔══██╗██╔══██║██║   ██║'"$echo_normal"
echo -e "$echo_yellow"' ╚██████╗██║  ██║██║  ██║██║  ██║   ██║   ██████╔╝██║  ██║╚██████╔╝'"$echo_normal"
echo -e "$echo_green"'  ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ '"$echo_normal"
echo -e "$echo_green"'                                                   ...is installed!'"$echo_normal"
echo
echo -e "${echo_cyan}Start a new shell or, if you are re-installing CarryBag, run ${echo_white}sourcep${echo_cyan} to source any updates.$echo_normal"
echo -e "${echo_cyan}Use ${echo_white}bash-it show [aliases|completions|plugins]${echo_cyan} to manage functionality.$echo_normal"

exit 0
