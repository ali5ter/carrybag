#!/usr/bin/env bash
# Theme for Bash it called 'alister' as delivered by CarryBag

prompt_command () {

    git_prompt_vars

    PS1="\n\
${cyan}\@ \
$( [ -e ~/.meetingAlert ] && cat ~/.meetingAlert) \
${yellow}\u@\h \
${bold_white}\W\
$(__git_ps1 " ${white}${background_purple} $SCM_BRANCH ${normal}") \
$([ $(jobs -p | wc -l) -gt '0' ] && echo -n "${red}●" || echo -n "○") \
${normal}
〉"
}

PROMPT_COMMAND=prompt_command
