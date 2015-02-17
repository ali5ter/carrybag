cite about-plugin
about-plugin 'CarryBag configurations and functions for OSX'

[ -r ~/.dircolors ] && eval "$(dircolors ~/.dircolors)"
alias ls="ls --color=always"

## CNC workflow config
alias ink="inkscape &"
alias pycam="python ~/bin/pycam &"
alias cambam="mono ~/bin/CamBam0.9.8/CamBam.exe &"
alias ard="~/bin/arduino &"
alias gcs="java -jar -Xmx256m ~/bin/UniversalGcodeSender.jar &"

git config --global credential.helper 'cache --timeout=3600'

system_maintenance () {
    sudo apt-get update && \            # get pacakges up-to-date
    sudo apt-get -y upgrade && \        # apply any updates
    sudo apt-get -y dist-upgrade && \   # ..
    sudo apt-get -y autoremove          # cleam up the crud
    sudo npm update -g  # get npm global packages up-to-date
    # if there's a problem then we'd do...
    # (curl https://npmjs.org/install.sh | sudo sh) && rm install.sh
}
