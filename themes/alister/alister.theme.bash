#!/usr/bin/env bash
# Theme for Bash it called 'alister' as delivered by CarryBag

prompt_command () {

    scm_prompt_vars

    SCM_PROMPT=''
    [[ "${SCM_NONE_CHAR}" != "${SCM_CHAR}" ]] &&
        SCM_PROMPT=" ${white}${background_purple} $SCM_BRANCH ${normal}"

    JOBS_PROMPT='○'
    [[ $(jobs -sp | wc -l) -gt 0 ]] &&
        JOBS_PROMPT="${red}●"

    PS1="\n${cyan}\@ ${yellow}\u@\h ${bold_white}\W${SCM_PROMPT} ${JOBS_PROMPT} ${normal}\n〉"
}

PROMPT_COMMAND=prompt_command
