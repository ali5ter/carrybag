# ----------------------------------------------------------------------------
# @file profile
# @see color
# @author Alister Lewis-Bowen (alister@different.com)
# ----------------------------------------------------------------------------

# Set environment vars
# ----------------------------------------------------------------------------

export PATH=.:~/bin:/usr/local/bin:/usr/bin:$PATH; # standard path extensions

export PS1="$(color bd white)[$(color green)\u$(color magenta)@$(color green)\
\h$(color magenta) $(color red)\W$(color bd white)]$ $(color)";
export PS1="[\u@\h \W] $";

if [ `uname` == 'Darwin' ]; then                   # OSX Tiger XCode paths
  export PATH=/Developer/Tools:/Developer/Applications:$PATH;
fi

if [ -e /Applications/MAMP ]; then                 # OSX MAMP paths
  export PATH=/Applications/MAMP/Library/bin:$PATH;
fi

# Bash options
# ----------------------------------------------------------------------------
shopt -s cdspell    # Correct minor spelling errors in a cd command.
shopt -s histappend # Append to history rather than overwrite
shopt -s dotglob    # Show dot files in path expansion

# Editor options
# ----------------------------------------------------------------------------

set -o vi;                   # set vi history 

if [ -e /usr/bin/vi ]; then
    export EDITOR='/usr/bin/vi'; # default to vi editor
fi

if [ -e dircolors ]; then
    export `dircolors`;      # set up shell colors
fi

export CLICOLOR=1; # OSX only

# Alias shell commands
# ----------------------------------------------------------------------------

if [ `uname` != 'Darwin' ]; then # colours not good on opaque bg of OSX Tiger/Leopard Terminal
    alias ls='ls -FG --color=auto';
else
    alias ls='ls -F';   # non-color listing
fi

alias rm='rm -i';     # confirm any delete

# Alias extra commands
# ----------------------------------------------------------------------------

psgrep() {
    if [ ! -z $1 ] ; then
        echo "Grepping for processes matching $1..."
            ps aux | grep $1 | grep -v grep
        else
            echo "!! Need name to grep for"
        fi
}

start() {
    match=`ls -1 /Applications | grep -i $1 | perl -pe 's/^(.*)\/$/$1/' | perl -pe 's/\s/\\\ /g'`;
    num=`ls -1 /Applications | grep -i $1 | wc -l`;
    if [ "$num" -eq 1 ]; then
        echo "$(color green)Will try to open /Applications/$match$(color)"
        open /Applications/$match
    else
        echo "$(color red)Can't open $match$(color)"
    fi;
}

if [ -e ~/bin/drush ]; then
    alias drush='php ~/bin/drush/drush.php';
fi

if [ -e /usr/local/bin/icalBuddy ]; then
    alias meetings="icalBuddy -sc -n -f -eep notes eventsToday";
fi

if [ -e /Applications/MAMP ]; then
    alias phplog="tail -f /Applications/MAMP/logs/php_error.log";
    alias clean_mamp="cd /Applications/MAMP; find . -name "*.pid" | xargs rm -f";
fi

if [ -e /var/log/httpd/error_log ]; then
    alias wwwerror="sudo tail -f /var/log/httpd/error_log";
fi;

if [ -e /var/log/system.log ]; then
    alias syslog="sudo tail -f /var/log/system.log";
else
    alias syslog="sudo tail -f /var/log/messages";
fi

alias alllogs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f";

if [ -e ~/Applications/synergy ]; then
    alias synergys="ps aux | grep synergys | grep -v grep | awk '{print $2}' | xargs kill -9; ~/Applications/synergy/synergys -c ~/Applications/synergy/synergy.conf -n tinker -f";
    alias synergyc="~/Applications/synergy/synergyc --name vmware -f tinker";
fi

alias hosts="sudo co -l /etc/hosts; sudo vim /etc/hosts; sudo ci /etc/hosts; sudo co /etc/hosts; sudo cp /etc/hosts /Users/$USER/Resources/Configurations/hosts";

alias clean_svn='find . | egrep svn | xargs rm -R';
alias show_svn='find . | egrep svn';

alias un='tar -zxf $1';

# Alias host logins
# ----------------------------------------------------------------------------

if [ -f ~/.hosts ]; then
    . ~/.hosts
fi

# Get local aliases and functions
# ----------------------------------------------------------------------------

if [ -f ~/.profile_local ]; then
    . ~/.profile_local
fi

