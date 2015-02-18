cite about-plugin
about-plugin 'CarryBag configurations and functions for OSX'

## Return if non-interactive shell
case $- in
    *i*)    ;;
    *)      return;;
esac

## Colors
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

## Enable completion
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        source /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        source /etc/bash_completion
    fi
fi

## CNC workflow config
alias ink="inkscape &"
alias pycam="python ~/bin/pycam &"
alias cambam="mono ~/bin/CamBam0.9.8/CamBam.exe &"
alias ard="~/bin/arduino &"
alias gcs="java -jar -Xmx256m ~/bin/UniversalGcodeSender.jar &"

git config --global credential.helper 'cache --timeout=3600'

system_maintenance () {

    about 'Clean out typical OS cruft'
    group 'linux'
}
