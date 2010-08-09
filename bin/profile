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

if [ -e fink ]; then                               # OSX Fink paths
  export PATH=/sw/bin/:/sw/sbin:$PATH;
fi

if [ -e /Applications/MAMP ]; then                 # OSX MAMP paths
  export PATH=/Applications/MAMP/Library/bin:$PATH;
fi

if [ -e ~/bin/shunit ]; then                       # ShUnit path
    export SHUNIT_HOME=~/bin/shunit;
    export PATH=$PATH:$SHUNIT_HOME;
fi

if [ -e /opt/local ]; then                         # MacPort path
    export PATH=/opt/local/bin:/opt/local/sbin:$PATH;
    export MANPATH=/opt/local/share/man:$MANPATH
fi

export USER_BASH_COMPLETION_DIR=~/.bash_completion.d

if [ -f /opt/local/etc/bash_completion ]; then     # MacPort bash completion
    . /opt/local/etc/bash_completion
fi

if [ -e ~/bin/p4 ]; then                           # OSX p4
    export P4CONFIG=.p4config;
fi

if [ -e ~/bin/apache-maven ]; then                 # OSX Maven
    export M2_HOME=~/bin/apache-maven;
    export MAVEN_OPTS='-Xmx1024M -XX:MaxPermSize=128m';
    alias mvn='~/bin/apache-maven/bin/mvn';
fi

# Editor options
# ----------------------------------------------------------------------------

set -o vi;                   # set vi history 

if [ -e /usr/bin/vi ]; then
    export EDITOR='/usr/bin/vi'; # default to vi editor
fi

if [ -e dircolors ]; then
    export `dircolors`;      # set up shell colors
fi

test -r /sw/bin/init.sh && . /sw/bin/init.sh; # OSX only

# Alias shell commands
# ----------------------------------------------------------------------------

if [ `uname` != 'Darwin' ]; then # colours not good on opaque bg of OSX Tiger/Leopard Terminal
    alias ls='ls -FG --color=auto';
else
    alias ls='ls -F';   # non-color listing
fi

alias rm='rm -i';     # confirm any delete

if [ -e ~/bin/vircs.sh ]; then
    alias vi='vircs.sh'; # revision control with any edit
fi

if [ -e ~/bin/drush ]; then
    alias drush='php ~/bin/drush/drush.php';
fi

# Alias extra commands
# ----------------------------------------------------------------------------

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

#alias profile='co -l ~/.profile; vim ~/.profile; ci ~/.profile; co ~/.profile;. ~/.profile';

alias clean_svn='find . | egrep svn | xargs rm -R';
alias show_svn='find . | egrep svn';

alias un='tar -zxf $1';

# Alias host logins
# ----------------------------------------------------------------------------

# Home

alias pair="ssh alister@erraj.pair.com $1";
alias dreamhost="ssh ali5ter@snocap.dreamhost.com $1";
alias dreamhost="ssh ali5ter@silversurfer.dreamhost.com $1";
alias blue="ssh alister@blue.different.com $1";
alias green="ssh alister@green.different.com $1";
alias red="ssh alister@red.different.com $1";
alias home="ssh alister@home.different.com -p 2112 $1";
alias hugo="ssh alister@hugo $1";
alias trott="ssh alister@trott $1";
alias newitt="ssh alister@newitt $1";
alias horton="ssh alister@horton $1";
alias cropley="ssh alister@cropley $1";

# Clients

alias casw="ssh alister@server1.casw.org $1";

# Harvard

#alias dev1="ssh abowen@itgdev.iic.harvard.edu $1"; # because i am
#alias rdev="ssh root@iic-dev.seas.harvard.edu $1"; # WhatacrazyW0rld
#alias rprod="ssh root@iic-prod.seas.harvard.edu $1"; # WhatacrazyW0rld
#alias dev="ssh abowen@iic-dev.seas.harvard.edu $1"; # because i am
#alias prod="ssh abowen@iic-prod.seas.harvard.edu $1"; # because i am
#alias iic="ssh web@star.iic.harvard.edu $1";      # for cloth sk
#alias im="ssh harviic@imageandmeaning.org $1";    # IIC
#alias scf="ssh abowen@scfdev.iic.harvard.edu $1"; # science

# VMware

alias prod="ssh alister@vcloud.eng.vmware.com $1"; # becuase i am
alias dev="ssh alister@vcloud-dev.eng.vmware.com $1"; # because i am
alias sof="ssh alister@sof-vcloud-dev.eng.vmware.com $1"; # because i am
#alias vm2="ssh alister@10.150.5.239 $1"; # because i am
#alias vm1="ssh alister@10.150.11.127 $1"; # because i am
alias vm1="ssh root@10.150.150.134 $1"; # akimbi

# The .script_aliases script is used to alias any of my .sh to name only
# ----------------------------------------------------------------------------

if [ -e ~/.script_aliases ]; then
    ~/.script_aliases;
fi;

# Get local aliases and functions
# ----------------------------------------------------------------------------

if [ -f ~/.profile_local ]; then
    . ~/.profile_local
fi




