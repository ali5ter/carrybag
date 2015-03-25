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
export ASKUSER_PREFIX="\033[0;33m"

## Prompt postfix
export ASKUSER_POSTFIX="\033[0m"

## Prompt choice prefix
export ASKUSER_CHOICE_PREFIX="$ASKUSER_PREFIX\t"

## Prompt choice postfix
export ASKUSER_CHOICE_POSTFIX="$ASKUSER_POSTFIX"

## Quiet mode off by default. Prompts are shown and user response expected. If
## false, the default is used.
export ASKUSER_QUIET=false

## User response to the last prompt
export ASKUSER_REPLY=''

## Convenience aliases
alias au='askuser'

## Set up working directory and pre-populate available prompts
[ -d "$ASKUSER_ACTIVE" ] || mkdir -p "$ASKUSER_ACTIVE"
[ -d "$ASKUSER_AVAIL" ] || {
    mkdir -p "$ASKUSER_AVAIL"
    cat <<ASKUSERDEFAULTS >> "$ASKUSER_AVAIL/askuser_test.txt"
# AskUser utility: Example prompt definitions file

#
#   You can define simple questions that expect a y (yes) or n (no) answer.
#   The following prompt definition defaults to the answer yes
#
auex1:YESNO:Is yellow the color of the liqueur Galliano?:y

#
#   Or a question with a free-form answer like this...
#
auex2:FREEFORM:External network IP address:10.0.1.100

#
#   Or like this...
#
auex4:FREEFORM:Your full time occupation is:Datafication Ideologist

#
#   If you want to use the ':' character, then escape it first, like this...
#
auex5:FREEFORM:What is the endpoint URL?:http\://192.186.1.101\:8001

#
#   If you want the user to select from a choice of answers, you create a
#   definition like the following:
#
auex6:CHOICE:In what body organs would you find Alveoli?:Ears|*Lungs|Kidneys

#
#   Of course you can also leave the default answer empty...
#
auex7:FREEFORM:What is your user name?:

#
#   There may be times where you want to generate the default answer at runtime.
#   To do this, leave the default answer blank and supply the answer using the
#   --default option, like this...
#
#   askuser auex7 --default "\$USER"
#
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

Quite mode, as set by the boolean environment variable ASKUSER_QUIET, or though
the ${echo_bold_white}--quiet${echo_normal} and ${echo_bold_white}--interactive\
${echo_normal} options, prevents the prompt interaction and
assumes the default answer. Quiet mode is set to false by default so the prompt
is shown to the user.

For situations where the default can only be derived at runtime, a command to
generate the default value can be supplied using the ${echo_bold_white}\
--default${echo_normal} option.

The user reply to a managed user interaction is stored in the environment
variable ASKUSER_REPLY. If quiet mode was used, this variable contains the
default value.

USAGE:
    ${echo_bold_white}askuser ${echo_underline_white}key${echo_normal} \
${echo_bold_white}[--default ${echo_underline_white}value\
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
        YESNO ...... y (yes) or n (no) answer prompt
        FREEFORM ... free from answer prompt
        CHOICE ..... mutiple choice answer prompt
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
        This free-form prompt definition:
            fullname0101:FREEFORM:What is your full name?:
        will display:
            ${ASKUSER_PREFIX}What is your full name? []: ${ASKUSER_POSTFIX}
        This multiple choice prompt definition:
            eyetest23:CHOICE:The dominant color is:red|*green|blue
        will display:
            ${ASKUSER_PREFIX}The dominant color is${ASKUSER_POSTFIX}
            ${ASKUSER_CHOICE_PREFIX}[1] red${ASKUSER_CHOICE_POSTFIX}
            ${ASKUSER_CHOICE_PREFIX}[2] green${ASKUSER_CHOICE_POSTFIX}
            ${ASKUSER_CHOICE_PREFIX}[3] blue${ASKUSER_CHOICE_POSTFIX}
            ${ASKUSER_PREFIX}[2]: ${ASKUSER_POSTFIX}

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
                echo -e "\t${echo_green}$key${echo_normal} -> $prompt${echo_normal}"
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

_askuser_defaultchoices_for_key () {

    local default=$(_askuser_field_for_key "$1" 4)

    default=${default:-$ASKUSER_DEFAULT}
    IFS="|" read -ra values <<< "$default"
    for (( i=0; i<${#values[@]}; i++)); do echo "$((i+1)):${values[$i]}"; done
}

_askuser_default_for_key () {

    local default=$(_askuser_field_for_key "$1" 4)
    local type=$(_askuser_type_for_key "$1")

    default=${default:-$ASKUSER_DEFAULT}
    case "$type" in
        CHOICE)
            default="$(_askuser_defaultchoices_for_key "$1" | \
                grep -n '\*' | cut -d':' -f1)"
            ;;
    esac
    echo "$default"
}

_askuser_display_prompt_for_key () {

    local key="$1"
    local type=$(_askuser_type_for_key "$1")
    local prompt="$ASKUSER_PREFIX"

    prompt="${prompt}$(_askuser_prompt_for_key "$key") "
    case "$type" in
        CHOICE)
            prompt="${prompt}\n"
            prompt="${prompt}$(_askuser_display_choices_for_key "$key")\n"
            prompt="${prompt}$ASKUSER_PREFIX"
            ;;
    esac
    prompt="${prompt}[$(_askuser_default_for_key "$key")]: "
    prompt="${prompt}$ASKUSER_POSTFIX"
    echo -ne "$prompt"
}

_askuser_display_choices_for_key () {

    local key="$1"
    local choice=''

    for value in $(_askuser_defaultchoices_for_key "$1"); do
        choice="${choice}$ASKUSER_CHOICE_PREFIX"
        choice="${choice}[$(echo "$value" | cut -d':' -f1)] ";
        choice="${choice}$(echo "$value" | cut -d':' -f2 | sed -e s/\*//g)";
        choice="${choice}${ASKUSER_CHOICE_POSTFIX}\n"
    done
    echo -e "$choice"
}


_askuser_validate_value_for_key () {

    local key="$1"; shift
    local value="$*"
    local values=$(_askuser_defaultchoices_for_key "$key")
    local type=$(_askuser_type_for_key "$key")
    local choices=()

    for choice in $values; do choices+=("$choice"); done

    if [[ -z "$reply" || "$reply" == "$default" ]]; then
        ## When the user enters no value or the same value as the default,
        ## then consider this valid and set ASKUSER_REPLY
        ASKUSER_REPLY="$default"
    else
        ## When the user enters aa value different from the default, validate
        ## it, store this as the new default abd set ASKUSER_REPLY
        case "$type" in
            YESNO)
                [[ "$value" == 'n' || "$value" == 'y' ]] || {
                    echo "Please answer y (for yes) or n (for no)."
                    return 1
                }
                ;;
            CHOICE)
                [[ $value =~ ^[0-9]+$ && $value -ge 1 && $value -le ${#choices[@]} ]] || {
                    echo "Please answer 1 to ${#choices[@]}."
                    return 1
                }
                ;;
        esac
        askuser "$key" set_to "$reply"
        ASKUSER_REPLY="$reply"
    fi

    ## Convert choice reply from index to value
    [ "$type" == 'CHOICE' ] && {
        value="$ASKUSER_REPLY"
        for choice in $values; do
            echo "$choice" | egrep "^$value:" >/dev/null && \
                ASKUSER_REPLY=$(echo "$choice" | cut -d':' -f2 | sed -e s/\*//g)
        done
    }

    return 0
}

_askuser_process_prompt_for_key () {

    local key=$1

    _askuser_display_prompt_for_key "$key"
    read reply
    ## <rant> which bash until loop worked like an until loop
    until _askuser_validate_value_for_key "$key" "$reply"; do
        _askuser_display_prompt_for_key "$key"
        read reply
    done
    return 0
}

askuser () {

    about 'utility to prompt the user for input and manage response defaults'
    group 'askuser'

    local key=$1
    local verb=$2
    local value=$3

    ## Gather up all the active prompt definitions
    ASKUSER_PROMPTS="$ASKUSER_ACTIVE/.all_prompts"
    _askuser_all_prompts > "$ASKUSER_PROMPTS"

    ## Must supply at least the key for an active prompt defintion
    [ -z "$key" ] && { _askuser_help; return 1; }

    ## Fetch the prompt definition data for the key provided. If the prompt is
    ## not found, then show the active prompt definitions found.
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
        ## 1. Set the reponse to the default with no user interaction if
        ##    ASKUSER_QUIET is true, or
        ## 2. Present the prompt to the user and manage the interaction to
        ##    set the response to the value of the users reply.
        while [[ $# -gt 0 ]]; do
            case $1 in
                -d|--default)       ASKUSER_DEFAULT=$2; shift ;;
                -q|--quiet)         ASKUSER_QUIET=true ;;
                -i|--interactive)   ASKUSER_QUIET=false ;;
            esac
            shift
        done
        default=$(_askuser_default_for_key "$key")
        if $ASKUSER_QUIET; then
            export ASKUSER_REPLY="$default"
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
                sed -E "s/(^$key:.+):$default$/\1:$value/" "$file" > "$file.tmp" \
                    && mv "$file.tmp" "$file"
                ;;
        esac
    fi

    return 0;
}
