cite about-plugin
about-plugin 'CarryBag configurations and functions for OSX'

## Colors
[ -r ~/.dircolors ] && eval "$(dircolors ~/.dircolors)"
[ -e dircolors ] && export `dircolors`
alias ls="ls --color=always"

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
