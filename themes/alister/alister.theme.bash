#!/usr/bin/env bash
# Theme for Bash it called 'alister' as delivered by CarryBag

prompt_command () {

    scm_prompt_vars

    SCM_PROMPT=''
    [[ "${SCM_NONE_CHAR}" != "${SCM_CHAR}" ]] &&
        SCM_PROMPT=" ${white}${background_purple} $SCM_BRANCH ${normal}"

    PS1="\n\
${cyan}\@ \
$( [ -e ~/.meetingAlert ] && cat ~/.meetingAlert) \
${yellow}\u@\h \
${bold_white}\W\
${SCM_PROMPT} \
$([ $(jobs -p | wc -l) -gt '0' ] && echo -n "${red}●" || echo -n "○") \
${normal}
〉"
}

PROMPT_COMMAND=prompt_command
