#
# @file profile
# ★ Bash configuration
# @author Alister Lewis-Bowen <alister@different.com>
#

#
# Options
#

shopt -s cdspell    # Correct minor spelling errors in a cd command.
shopt -s histappend # Append to history rather than overwrite
shopt -s dotglob    # Show dot files in path expansion

#
# Paths
#

export PATH=.:$HOME/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:$PATH
export MANPATH=/usr/local/man:$MANPATH


#
# Additional path definitions
#

[ -f ~/.paths_local ] && . ~/.paths_local

#
# Prompt
#

export PS1="[\u@\h \W] $";

#
# Colors
#

[ -e dircolors ] && export `dircolors`;
export CLICOLOR=1; # OSX only

#
# Editor
#

export EDITOR='vi'  # set default to vi
set -o vi           # set vi history

if [ "$(command -v mvim)" != "" ]; then
    export EDITOR='mvim'    # default to mac vim if installed
    alias vi='mvim'
fi

#
# Aliases existing commands
#

alias rm='rm -i'    # confirm any delete
alias ls='ls -F'    # show dirs, exec and sym link files

#
# Additional commands
#

#
# ffile string ... find a file from this directory
#

ffile () { find . | grep -i "$1" ;  }

#
# ftext string ... find text the files from this directory
#

ftext () { find . | xargs grep -i "$1" ; }

#
# fproc string ... find a process
#

fproc () { ps aux | grep "$1" | grep -v 'grep' ; }

#
# kproc string ... kill a set of processes
#

kproc () { fproc "$@" | awk '{print $2}' | xargs kill -9 ; }

#
# allogs ... (all-logs) tail all logs under /var/log
#

alias allogs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f";

#
# wwwerror ... tail just the httpd error log
#

[ -e /var/log/httpd/error_log ] && alias wwwerror="sudo tail -f /var/log/httpd/error_log";

#
# rcsedit file ... rcs wrapped edit
#

rcsedit () {
    if [ "$(command -v rcs)" == "" ]; then
        [ ! -e $(dirname $1)/RCS ] && mkdir $(dirname $1)/RCS   # Create RCS dir next to file
        co -l $1; /usr/bin/vi $1; ci $1; co $1                  # rcs wrapped edit
    else
        $EDITOR $1;                                             # Regular edit if rcs not installed
    fi
}

#
# hosts ... edit the /etc/hosts file
#

alias hosts="sudo co -l /etc/hosts; sudo vim /etc/hosts; sudo ci /etc/hosts; sudo co /etc/hosts; sudo cp /etc/hosts /Users/$USER/Resources/Configurations/hosts";

#
# edit and source .profile
#
alias sourcep="source ~/.profile"

#
# Additional alias customizations
#

[ -f ~/.alias_local ] && . ~/.alias_local

#
# Machines
# e.g. alias foo='ssh bar@foo.com -p 123 $1'
#

[ -f ~/.machines_local ] && . ~/.machines_local

#
# Additional extended capabilities
#

[ -f ~/.profile_local ] && . ~/.profile_local

