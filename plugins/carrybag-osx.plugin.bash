cite about-plugin
about-plugin 'CarryBag OSX specific config and functions'

## Colors
export CLICOLOR=1
#alias ls='CLICOLOR_FORCE=1 ls -G'
alias more='less -R'

## Perl
export PERL_MB_OPT="--install_base \"$HOME/perl5\""
export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"

## Python
[ -d /usr/local/lib/python2.7 ] && export PYTHONPATH=/usr/local/lib/python2.7/site-packages

## Java
export JAVA_HOME=$(/usr/libexec/java_home)  # using XCode command line tools util

## OSX developer tools
[ -d /Developer ] && export PATH=/Developer/Tools:/Developer/Applications:$PATH

## MAMP
[ -d /Applications/MAMP ] && {
    export PATH=/Applications/MAMP/Library/bin:$PATH
    alias phplog="tail -f /Applications/MAMP/logs/php_error.log"
    alias clean_mamp="cd /Applications/MAMP; find . -name \"*.pid\" -print0 | xargs -0 rm -f"
}

## Heroku toolkit
[ -d /usr/local/heroku ] && export PATH=/usr/local/heroku/bin:$PATH

## Android developer tools
[ -d /Applications/ADT\ Bundle\ Mac ] && {
    export PATH='/Applications/ADT Bundle Mac/sdk/platform-tools':$PATH
    export PATH='/Applications/ADT Bundle Mac/sdk/tools':$PATH
}

## For apps using wget
alias wget='curl -CO'

## SourceTree
[ -d /Applications/SourceTree.app ] && \
    alias sourcetree="'open -a /Applications/SourceTree.app'"

## Do not hide the  Library director
chflags nohidden ~/Library

## @see https://www.vmware.com/support/developer/ovf/ovf350/ovftool-350-userguide.pdf
ovftool () {

    about 'VMware OVF tool'
    group 'osx'

    local path=/Applications/VMware\ OVF\ Tool
    if [ -d /Applications/VMware\ OVF\ Tool ]; then
        "$path/ovftool" "$@"
    else
        echo "${echo yellow}ovftool is not installed${echo_normal}"
    fi
}

fword () {

    about 'open OSX Dictionary for the given text'
    param 'text to look up'
    example '$ fword abortifacient'
    group 'osx'

    open dict:///"$*"
}

pman () {

    about 'show man pages in OSX Preview'
    param 'command'
    example '$ pman find'
    group 'osx'

    man -t "$@"| open -f -a /Applications/Preview.app
}

res () {

    about 'show the current screen resolution'
    group 'osx'

    osascript -e 'tell application "Finder" to get bounds of window of desktop' |
        sed -e 's/0, 0, \(.*\), \(.*\)/\1x\2/'
}

system_maintenance () {

    about 'Clean out typical OS cruft'
    group 'osx'

    sudo periodic daily weekly monthly

    # @see http://www.macgasm.net/2013/01/18/good-morning-your-mac-keeps-a-log-of-all-your-downloads/
    sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'
}
