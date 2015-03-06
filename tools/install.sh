#set +x!/usr/bin/env bash
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

## Fetch 3rd party packages
$QUIET || {
    echo -ne "\033[0;33mWant to fetch the 3rd party packagese? [y/N] \033[0m"
    read -n 1 reply
    case "$reply" in
        Y|y)
            echo -e "\n\033[0;36mFetching/updating 3rd party packages.\033[0m"
            git submodule update --init --recursive ## updated to the commit recorded by the submodule reference
    esac
}

## Load convenience functions for color
source "$CB_BASE/3rdparty/bash-it/themes/colors.theme.bash"

## Move Bash-it into place
$UPDATE || {
    [ -d "$BASH_IT" ] && rm -fR "$BASH_IT"
    cp -r "$CB_BASE/3rdparty/bash-it" "$BASH_IT"
    echo -e "${echo_cyan}Installing clean Bash-it environment${echo_normal}"
}

## CarryBag includes
source "$CB_BASE/lib/cblib_bashit.bash"
source "$CB_BASE/lib/cblib_appearance.bash"
source "$CB_BASE/lib/cblib_runcom.bash"
source "$CB_BASE/lib/cblib_git.bash"
case "$OSTYPE" in
    darwin*)   source "$CB_BASE/lib/cblib_homebrew.bash" ;;
    *)         source "$CB_BASE/lib/cblib_apt.bash" ;;
esac
source "$CB_BASE/lib/cblib_node.bash"
source "$CB_BASE/lib/cblib_ruby.bash"
source "$CB_BASE/lib/cblib_vim.bash"

## CarryBag configurations
$UPDATE || {
    ## Mandatory
    build_carrybag_bash_runcom
    build_carrybag_git_config
    build_carrybag_git_ignore
    case "$OSTYPE" in
        darwin*)   build_carrybag_homebrew_config ;;
        *)         build_carrybag_apt_config ;;
    esac
    build_carrybag_node_config
    build_carrybag_vim_config
    add_to_bash_runcom "export CB_BASE=\"$CB_BASE\""
    ## Optional
    $QUIET || {
        echo -ne "${echo_yellow}Install nativescript? [y|N]${echo_normal} "
        read -n 1 reply
        case "$reply" in
            Y|y)
                echo
                source "$CB_BASE/lib/cblib_nativescript.bash"
                build_carrybag_nativescript_configuration
                ;;
        esac
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
