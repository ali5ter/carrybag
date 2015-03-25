#!/usr/bin/env bash
# Install CarryBag

set -e

## Check we got git
hash git >/dev/null 2>&1 || {
    echo -e "\033[0;33mUnable to find git.\033[0m Please install it and try installing again."
    exit
}

_help () {
    local content="
Installer for the CarryBag bash shell environment.

Usage: install.sh [options]

Options:
-i, --interactive   Interactive install.
-q, --quiet         No questions. Just use the defaults.
-u, --update        Only moves aliases, completions, plugins and themes into place.
"
    echo -e "$content"
}

## Default run modes depending whether CarryBag installed
UPDATE=false
if [ -z "$CB_BASE" ]; then
    export CB_BASE=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )
    export BASH_IT=~/.bash_it
    QUIET=false
else
    QUIET=true
fi

## Parse options
while [[ $# -gt 0 ]]; do
    option="$1"
    case $option in
        -i|--interactive)   QUIET=false; shift ;;
        -q|--quiet)         QUIET=true; shift ;;
        -u|--update)        UPDATE=true; shift ;;
        *)                  _help; exit 0;;
    esac
done

## Add plugin and lib dirs to path and tell bash to use path to search for
## files to source
export PATH="$CB_BASE/lib:$CB_BASE/plugins:$PATH"
shopt -s sourcepath

## Load askuser utility and provide prompt definitions file
cite () { return 0; };          # Hack to get around undefined metadata calls
about-plugin () { return 0; }   # "
about () { return 0; }          # "
group () { return 0; }          # "
source askuser.plugin.bash
## Load the askuser carrybag install prompts and defaults
cp "$CB_BASE/templates/askuser.template" "$ASKUSER_AVAIL/carrybag.txt"
ASKUSER_QUIET="$QUIET"          # Pass through quiet mode flag

## Fetch 3rd party packages
askuser cb_3rdparty
[ "$ASKUSER_REPLY" == 'y' ] && {
    echo -e "\n\033[0;36mFetching/updating 3rd party packages.\033[0m"
    ## updated to the commit recorded by the submodule reference
    git submodule update --init --recursive
}

## Load bash-it functions for color
source "$CB_BASE/3rdparty/bash-it/themes/colors.theme.bash"

## CarryBag includes
source cblib_bashit.bash
source cblib_appearance.bash
source cblib_runcom.bash
source cblib_git.bash
case "$OSTYPE" in
    darwin*)
        source cblib_homebrew.bash
        source cblib_cask.bash
        ;;
    *)         source cblib_apt.bash ;;
esac
source cblib_node.bash
source cblib_ruby.bash
source cblib_vim.bash

_prompt_for_action () {

    local key=$1
    local action=$2
    local message=$3

    askuser "$key"
    [ "$ASKUSER_REPLY" == 'y' ] && {
        [ -z "$message" ] || echo -e "${echo_cyan}${message}${echo_normal}"
        eval "$action"
    }
    return 0
}

## Update shell with CarryBag configuration
$UPDATE || {

    _prompt_for_action cb_bash-it \
        "build_carrybag_bash-it_config && build_carrybag_bash_runcom"
    _prompt_for_action cb_appearance \
        "build_carryback_apperance"
    _prompt_for_action cb_git \
        "build_carrybag_git_config && build_carrybag_git_ignore"

    case "$OSTYPE" in
        darwin*)
            _prompt_for_action cb_brew \
                "build_carrybag_homebrew_config"
            _prompt_for_action cb_cask \
                "build_carrybag_cask_config"
            ;;
        *)
            _prompt_for_action cb_apt \
                "build_carrybag_apt_config"
            ;;
    esac

    _prompt_for_action cb_node \
        "build_carrybag_node_config"
    _prompt_for_action cb_vim \
        "build_carrybag_vim_config"

    add_to_bash_runcom "export CB_BASE=\"$CB_BASE\""

    ## Optional CarryBag configurations
    $QUIET || {

        _prompt_for_action cb_nativescript \
            "echo && source cblib_nativescript.bash && build_carrybag_nativescript_config"
    }
}

## Preload Bash-it & CarryBag addons
preload_carrybag_addons
preload_carrybag_themes

## Load Bash-it libs to help enable addons
source "${BASH_IT}/lib/composure.sh"
cite _about _param _example _group _author _version
for file in ${BASH_IT}/lib/*.bash; do source "$file"; done

## Enable addons that come with Bash-it & CarryBag
echo -e "${echo_cyan}Pre-loading addons:$echo_normal"
bash-it-enable alias general
bash-it-enable alias carrybag-general
bash-it-enable alias git
bash-it-enable alias vim
bash-it-enable completion bash-it
bash-it-enable completion defaults
bash-it-enable completion git
bash-it-enable completion jump
bash-it-enable completion ssh
bash-it-enable plugin askuser
bash-it-enable plugin base
bash-it-enable plugin carrybag-general
bash-it-enable plugin carrybag-ctags
bash-it-enable plugin dirs
bash-it-enable plugin extract
bash-it-enable plugin git
bash-it-enable plugin gping
bash-it-enable plugin jump
bash-it-enable plugin ssh
bash-it-enable plugin zzz-carrybag-overrides
case "$OSTYPE" in
    darwin*)
        bash-it-enable alias homebrew
        bash-it-enable alias osx
        bash-it-enable completion brew
        bash-it-enable plugin carrybag-osx
        bash-it-enable plugin osx
        ;;
    *)
        bash-it-enable plugin carrybag-linux
        ;;
esac

if $UPDATE; then verb='updated'; else verb='installed'; fi
echo
echo -e "$echo_yellow"'  ██████╗ █████╗ ██████╗ ██████╗ ██╗   ██╗██████╗  █████╗  ██████╗ '"$echo_normal"
echo -e "$echo_green"' ██╔════╝██╔══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝██╔══██╗██╔══██╗██╔════╝ '"$echo_normal"
echo -e "$echo_yellow"' ██║     ███████║██████╔╝██████╔╝ ╚████╔╝ ██████╔╝███████║██║  ███╗'"$echo_normal"
echo -e "$echo_green"' ██║     ██╔══██║██╔══██╗██╔══██╗  ╚██╔╝  ██╔══██╗██╔══██║██║   ██║'"$echo_normal"
echo -e "$echo_yellow"' ╚██████╗██║  ██║██║  ██║██║  ██║   ██║   ██████╔╝██║  ██║╚██████╔╝'"$echo_normal"
echo -e "$echo_green"'  ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═════╝ ╚═╝  ╚═╝ ╚═════╝ '"$echo_normal"
echo -e "$echo_green"'                                                   '...is ${verb}!"$echo_normal"
echo
echo -e "${echo_cyan}Start a new shell or, if you are re-installing CarryBag, run ${echo_white}sourcep${echo_cyan} to source any updates.$echo_normal"
echo -e "${echo_cyan}Use ${echo_white}bash-it show [aliases|completions|plugins]${echo_cyan} to manage functionality.$echo_normal"

exit 0
