cite about-plugin
about-plugin 'utility to prompt for user input'

_cblib_askuser=1

## Working directory
export ASKUSER=~/.askuser

## Active prompts directory
export ASKUSER_ACTIVE="$ASKUSER/active"

## Available prompts directory
export ASKUSER_AVAIL="$ASKUSER/available"

## Prompt prefix
export ASKUSER_PREFIX="${echo_yellow}"

## Prompt postfix
export ASKUSER_POSTFIX="${echo_normal}"

## Quiet mode off by default. Prompts are shown and user response expected. If
## false, the default is used.
export ASKUSER_QUIET=false

## User response to the last prompt
export ASKUSER_REPLY=''

## Convenience aliases
alias au='askuser'

## Prepopulate available prompts
[ -d "$ASKUSER_AVAIL" ] || {
    mkdir -p "$ASKUSER_AVAIL"
    cat <<ASKUSERDEFAULTS >> "$ASKUSER_AVAIL/askuser_test.txt"
# AskUser utility: Example available prompts file

#   This is a sample question that expects a y (yes) or n (no) answer.
#
auex1:YESNO:Can peanut butter live without jelly?:n

#   A simple question that expects a freeform answer.
#
auex2:FREEFORM:Please confirm the name of the capitol of England:London

#   Another simple question that expects a freeform answer.
#   Notice there is no initial default here. This will result in no default
#   being displayed to the user after the prompt. A default can be supplied
#   dynamically for this prompt using the --default option
#   Example:
#   askuser dynamic --default \$USER --command "ls /Users/\\\$ASKUSER_REPLY"
#
auex3:FREEFORM:What is your user name?:

ASKUSERDEFAULTS
}
[ -d "$ASKUSER_ACTIVE" ] || mkdir -p "$ASKUSER_ACTIVE"

_askuser_help () {
    local _help="
${echo_bold_white}Utility to prompt the user for input and manage response \
defaults${echo_normal}

This utility uses txt files that define the content and default response for a
user prompt. It will display the prompt, wait for the user input and record
this response back to this definition file.

You create these definition files under '$ASKUSER_AVAIL'.

An example file is provided in this directory for you to copy and create prompt
defintions for your own scripts. Each entry in the txt file is indexed by a key
and used as described below.

You can also pass a command which will be invoked for the default value. This is
useful when you want to use this utility in quiet (or non-interactive) mode.
Quite mode, as set by the boolean environment variable ASKUSER_QUIET. By default
this is set to false so the prompt is shown to the user but can also be set per
invocation.

For situations where the default can only be derived at runtime, a command to
generate the default value can be supplied

The user reply to a managed user interaction is stored in the environment
variable ASKUSER_REPLY. If quiet mode was used, this variable contains the
default value.

USAGE:
    ${echo_bold_white}askuser ${echo_underline_white}key${echo_normal}\
${echo_bold_white} [--command ${echo_underline_white}command${echo_normal}\
${echo_bold_white}] [--default ${echo_underline_white}value\
${echo_normal}${echo_bold_white}] [--quiet] [--interactive]${echo_normal}
        Display the prompt for ${echo_white}key${echo_normal} and provide the \
user response in ASKUSER_REPLY
        after the interaction has completed. If supplied, run ${echo_white}\
command${echo_normal} if
        ASKUSER_REPLY is equal to the current default value. If ASKUSER_QUIET is
        true, then the prompt will not be shown, the default chosen and, if
        supplied, the ${echo_white}command${echo_normal} run. If supplied, a \
${echo_white}value${echo_normal} for the default can be
        provided during invocation to be used if there is no existing default.
        This quiet mode of operation can also be controlled at invocation using
        the ${echo_white}quiet${echo_normal} or ${echo_white}interactive\
${echo_normal} options.

    ${echo_bold_white}askuser ${echo_underline_white}key${echo_normal}\
${echo_bold_white} is ${echo_normal}
        Display the current default value for ${echo_white}key${echo_normal}.

    ${echo_bold_white}askuser ${echo_underline_white}key${echo_normal}\
${echo_bold_white} is ${echo_underline_white}value${echo_normal}
        Return the boolean based on the comparison of the current default value
        for ${echo_white}key${echo_normal} and ${echo_white}value${echo_normal}.

    ${echo_bold_white}askuser ${echo_underline_white}key${echo_normal}\
${echo_bold_white} set_to ${echo_underline_white}value${echo_normal}
        Set the default value for ${echo_white}key${echo_normal} to \
${echo_white}value${echo_normal}.

ENVIRONMENT VARIABLES:
    ASKUSER
        Working directory for this utility. Currently set to '$ASKUSER'
    ASKUSER_ACTIVE
        The directory containing all the files of active prompt definitions.
        Currently set to '$ASKUSER_ACTIVE'
    ASKUSER_AVAIL
        The directoy containing all the files of available prompt definitions.
        Theses are kept as a way to reset the prompt defaults back to their
        original values. Currently set to '$ASKUSER_AVAIL'
    ASKUSER_PREFIX
    ASKUSER POSTFIX
        These contain any content to be added before and after the prompt
        content. By default they contain ANSII escape codes to set the prompt
        text to a yellow color. You can see the effect of these on the following
        example prompt content:
        ${ASKUSER_PREFIX}This is an example prompt: ${ASKUSER_POSTFIX}
    ASKUSER_QUIET
        This boolean variable controls quiet mode. Currently set to \
$($ASKUSER_QUIET && echo 'true' || echo 'false')

PROMPT DEFINITIONS:
    Any available prompt file is copied from the available directory to the
    active directory if it does not already exist there. After the user
    responds, their answer is written to the active prompt file in active
    directory.

    Comments and blank lines are ignored.

    Format for a prompt definition is
    key:type:prompt_text:default_answer

    where:
    key
        the unique idenfifier for the prompt
    type
        YESNO ... y (yes) or n (no) answer prompt
        FREEFORM ... free from answer prompt
    prompt_text
        the content of the prompt
    default_answer
        the value shown in the prompt and taken as the default answer if run in
        quiet mode or answered by the user

    EXAMPLES
        The following prompt definition:
            app_continue:YESNO:Do you want to continue?:y
        generates the following prompt:
            ${ASKUSER_PREFIX}Do you want to continue? [y]: ${ASKUSER_POSTFIX}
        This prompt definition:
            fullname0101:FREEFORM:What is your full name?:
        will display:
            ${ASKUSER_PREFIX}What is your full name? []: ${ASKUSER_POSTFIX}

    The list of active prompt definitions:
"
    echo -e "$_help"
    _askuser_all_prompts pretty
}

_askuser_all_prompts () {
    ## Return all active prompt definitions in one of two ways:
    ## 1. By default, each raw definition delimited by a carriage return, or
    ## 2. Using the 'pretty' param, list each definition per file in a human
    ##    readable format

    local pretty=false
    local key=''
    local prompt=''

    [ "$1" == 'pretty' ] && pretty=true

    [ -d "$ASKUSER_ACTIVE" ] || mkdir "$ASKUSER_ACTIVE"
    for filepath in $ASKUSER_AVAIL/*.txt; do
        file="$(basename "$filepath")"
        [ -e "$ASKUSER_ACTIVE/$file" ] || \
            cp "$ASKUSER_AVAIL/$file" "$ASKUSER_ACTIVE/$file"
    done

    if $pretty; then
        for file in $ASKUSER_ACTIVE/*.txt; do
            echo -e "${echo_cyan}$(basename "$file" .txt):${echo_normal}"
            while read -r def; do
                key="$(echo "$def" | cut -d':' -f1)"
                prompt=$(_askuser_display_prompt_for_key "$key")
                echo -e "\t${echo_green}$key -> $prompt${echo_normal}"
            done <<< "$(cat "$file" | egrep -v '^$' | egrep -v '^#')"
        done
    else
        cat $ASKUSER_ACTIVE/*.txt | egrep -v '^$' | egrep -v '^#'
    fi
}

_askuser_field_for_key () {

    if [ "$(cat "$ASKUSER_PROMPTS" | egrep -c "^$1:")" -gt '1' ]; then
        echo -e "${echo_red}askuser: Multiple prompt definitions found for key \
'$1'${echo_normal}"
        return 1
    else
        cat "$ASKUSER_PROMPTS" | egrep "^$1:" | cut -d':' -f"$2"
    fi
}

_askuser_prompt_for_key () { _askuser_field_for_key "$1" 3; }

_askuser_type_for_key () { _askuser_field_for_key "$1" 2; }

_askuser_default_for_key () {

    local default=$(_askuser_field_for_key "$1" 4)

    default=${default:-$ASKUSER_DEFAULT}
    echo "$default"
}

_askuser_validate_value_for_key () {

    local key="$1"; shift
    local value="$*"

    case "$(_askuser_type_for_key "$key")" in
        YESNO) [[ "$value" == 'n' || "$value" == 'y' ]] || return 1 ;;
    esac
    return 0
}

_askuser_display_prompt_for_key () {

    local prompt="$ASKUSER_PREFIX"

    prompt="${prompt}$(_askuser_prompt_for_key "$1") "
    prompt="${prompt}[$(_askuser_default_for_key "$1")]: "
    prompt="${prompt}$ASKUSER_POSTFIX"
    echo -ne "$prompt"
}

_askuser_process_prompt_for_key () {

    local key=$1
    local default="$(_askuser_default_for_key "$1")"
    ASKUSER_REPLY="$default"

    _askuser_display_prompt_for_key "$key"
    read reply
    if [[ -z "$reply" || "$reply" == "$default" ]]; then
        ## When the user enters no value or the same value as the default,
        ## then the default action is executed
        [ -z "$ASKUSER_CMD" ] || eval "$ASKUSER_CMD"
    else
        ## When the user enters aa value different from the default, validate
        ## it and store this as the new default
        _askuser_validate_value_for_key "$key" "$reply" && {
            askuser "$key" set_to "$reply"
            ASKUSER_REPLY="$reply"
        }
    fi
    return 0
}

askuser () {

    about 'utility to prompt the user for input and manage response defaults'
    group 'askuser'

    local key=$1
    local verb=$2
    local value=$3

    ASKUSER_PROMPTS="$ASKUSER_ACTIVE/.all_prompts"
    ASKUSER_CMD=''
    ASKUSER_DEFAULT=''

    ## Must supply at least the key for an active prompt defintion
    [ -z "$key" ] && { _askuser_help; return 1; }

    ## Fetch the prompt definition data for the key provided: All active prompt
    ## definition files are aggregated into ASKUSER_PROMPTS. If the prompt is
    ## not found, then show the active prompt definitions found.
    _askuser_all_prompts > "$ASKUSER_PROMPTS"
    local prompt=$(_askuser_prompt_for_key "$key")
    [ -z "$prompt" ] && {
        echo -e "${echo_red}askuser: Prompt for '$key' not found.${echo_normal} \
List of active prompts found:"
        _askuser_all_prompts pretty
        return 1
    }
    local default=$(_askuser_default_for_key "$key")

    if [[ -z "$verb" || $(echo "$verb" | grep -c '^\-\-') == '1' ]]; then
        ## Manage the prompt interaction in one of two ways:
        ## 1. Perform the default action and set the reponse to the default
        ##    with no user interaction if ASKUSER_QUIET is true, or
        ## 2. Present the prompt to the user and manage the interaction to
        ##    determine if the default action should run and set the response
        ##    to the value of the users reply.
        while [[ $# -gt 0 ]]; do
            case $1 in
                -c|--command)       ASKUSER_CMD=$2; shift ;;
                -d|--default)       ASKUSER_DEFAULT=$2; shift ;;
                -q|--quiet)         ASKUSER_QUIET=true ;;
                -i|--interactive)   ASKUSER_QUIET=false ;;
            esac
            shift
        done
        [ -z "$ASKUSER_DEFAULT" ] || default="$ASKUSER_DEFAULT"
        if $ASKUSER_QUIET; then
            export ASKUSER_REPLY="$default"
            [ -z "$ASKUSER_CMD" ] || eval "$ASKUSER_CMD"
        else
            _askuser_process_prompt_for_key "$key" "$default"
        fi
    else
        case "$verb" in
            ## Process the 'is' verb in one of two ways:
            ## 1. Show the current prompt default if no value provided, or
            ## 2. Compare the current prompt default with if the value provided
            is)
                if [ -z "$value" ]; then
                    echo "$default"
                else
                    [ "$default" == "$value" ] && return 0 || return 1
                fi
                ;;
            ## Process the 'set_to' verb: Set the current prompt default if
            ## the value is provided
            set_to)
                local file=$(find $ASKUSER_ACTIVE/*.txt -print0 | \
                    xargs -0 grep -H "^$key:" | cut -d':' -f1)
                sed -e s/:$default$/:$value/ "$file" > "$file.tmp" \
                    && mv "$file.tmp" "$file"
                ;;
        esac
    fi

    return 0;
}
