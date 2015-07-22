# CarryBag library functions for the bash runcom configurations

_cblib_runcom=1

RUNCOM_ADD_TOKEN="# CarryBag configuration"

bash_runcom () {

    case "$OSTYPE" in
        darwin*)    echo ~/.bash_profile ;;
        *)          echo ~/.bashrc ;;
    esac
}

current_wired_ip () {

    case "$OSTYPE" in
        darwin*)    ifconfig en0 | grep 'inet ' | cut -d' ' -f2 ;;
        *)          ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}' ;;
    esac
}

add_to_bash_runcom () {

    local text="$*"
    local BASHRC=$(bash_runcom)

    grep "$RUNCOM_ADD_TOKEN" "$BASHRC" >/dev/null || {
        sed -e "/# Load Bash It/i\\
$RUNCOM_ADD_TOKEN\\
\\
" "$BASHRC" > "$BASHRC.tmp" && mv "$BASHRC.tmp" "$BASHRC"
    }

    sed -e "/$RUNCOM_ADD_TOKEN/a\\
$text" "$BASHRC" > "$BASHRC.tmp" && mv "$BASHRC.tmp" "$BASHRC"

    return 0
}

build_carrybag_bash_runcom () {

    local BASHRC=$(bash_runcom)

    ## Use Bash-it runcom as a template
    [ -w "$BASHRC" ] && cp "$BASHRC" "$BASHRC.bak" &&
        echo -e "${echo_cyan}Your $(basename "$BASHRC") has been backed up to $BASHRC.bak${echo_normal}"
    cp "$BASH_IT/template/bash_profile.template.bash" "$BASHRC"

    ## Persist the OS specific bash runcom name
    add_to_bash_runcom "export BASHRC=\'$BASHRC\'"

    ## Include man pages added by package managers
    add_to_bash_runcom "export MANPATH=\'/usr/local/man:$MANPATH\'"

    ## Include plugin and lib paths and tell bash to look in this path for any
    ## files that might be source'd
    add_to_bash_runcom "export PATH=\"\$BASH_IT/plugins/available:\$PATH\""
    add_to_bash_runcom "export PATH=\"\$CB_BASE/lib:\$PATH\""
    add_to_bash_runcom "shopt -s sourcepath"

    ## Use the Bash-it theme provided by CarryBag
    add_to_bash_runcom "export BASH_IT_THEME='alister'"

    ## Make our default editor vim
    add_to_bash_runcom "export EDITOR='vim'"

    ## Make sure git uses the same edtor
    add_to_bash_runcom "export GIT_EDITOR=\'$EDITOR\'"

    ## Use vim to edit on the cmdl
    add_to_bash_runcom "set -o vi"

    ## Avoid storing duplicate command and those starting with spaces
    add_to_bash_runcom "HISTCONTROL=ignoreboth"

    ## Help correct minor typos when changing directories
    add_to_bash_runcom "shopt -s cdspell"

    ## Append commands to the history instead of overwriting when exiting
    add_to_bash_runcom "shopt -s histappend"

    ## Include dot files in pathname expansion (globbing)
    add_to_bash_runcom "shopt -s dotglob"

    ## Update window size vars after each command
    add_to_bash_runcom "shopt -s checkwinsize"

    ## Create IP environment variable
    add_to_bash_runcom "export IP=\'$(current_wired_ip)\'";

    echo -e "${echo_cyan}CarryBag modifications have been applied to $(basename "$BASHRC")${echo_normal}"

    return 0
}
