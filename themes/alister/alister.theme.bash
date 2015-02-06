#!/usr/bin/env bash

## Carrybag assumes bash completion is installed using Homebrew
## @see https://github.com/bobthecow/git-flow-completion/wiki/Install-Bash-git-completion
[ -f $(brew --prefix)/etc/bash_completion ] && . $(brew --prefix)/etc/bash_completion

prompt_command () {
    [ -e /Applications/Xcode.app/Contents/Developer/usr/share/git-core ] && {
        source /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-completion.bash
        source /Applications/Xcode.app/Contents/Developer/usr/share/git-core/git-prompt.sh
        PS1="\n\
${cyan}\@ \
$( [ -e ~/.meetingAlert ] && cat ~/.meetingAlert) \
${yellow}\u@\h \
${bold_white}\W\
$(__git_ps1 " ${white}${background_purple} %s ${normal}") \
$([ $(jobs -p | wc -l) -gt '0' ] && echo -n "${color red}●" || echo -n "○") \
${normal}
〉"
    }
}

PROMPT_COMMAND=prompt_command
