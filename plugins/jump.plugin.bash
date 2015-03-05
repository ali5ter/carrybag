cite about-plugin
about-plugin 'utility to navigate to bookmarked directories'

_cblib_jump=1

## Working directory
JUMP=~/.jump

## Directory bookmark store
JUMP_BOOKMARKS=~/.jump/bookmarks

## Convenience aliases
alias j='jump'
alias 'j+'='jump --add'
alias 'j-'='jump --delete'
alias jl='jump --list'

## Prepopulate jump bookmarks
if [ -f "$JUMP_BOOKMARKS" ]; then
    grep carrybag "$JUMP_BOOKMARKS" >/dev/null || \
        echo "carrybag::$CB_BASE" >> "$JUMP_BOOKMARKS"
else
    [ -d "$(dirname "$JUMP_BOOKMARKS")" ] || mkdir "$(dirname "$JUMP_BOOKMARKS")"
    echo "carrybag::$CB_BASE" > "$JUMP_BOOKMARKS"
fi

_jump_bookmark_exists () {

    [[ $(grep -c "^$1::" "$JUMP_BOOKMARKS") -gt '0' ]] && return 0
    return 1
}

jump () {

    about 'jump to a bookmarked directory. jump -h for more'
    group 'jump'

    local help="
${echo_bold_white}Jump to bookmarked directories${echo_normal}

Usage:
${echo_bold_white}jump ${echo_underline_white}name${echo_normal} will move you to the\
 directory bookmarked with ${echo_underline_white}name${echo_normal}
${echo_bold_white}jump -l|--list${echo_normal} to list the current bookmarked\
 directories
${echo_bold_white}jump -a|--add ${echo_underline_white}name${echo_normal} to bookmark the\
current directory with ${echo_underline_white}name${echo_normal}
${echo_bold_white}jump -p|--pathfor ${echo_underline_white}name${echo_normal} to display the\
current directory stored for ${echo_underline_white}name${echo_normal}
${echo_bold_white}jump -r|--remove ${echo_underline_white}name${echo_normal} to remove a\
 bookmark
"

    case "$1" in

        ''|--help|-h)  echo -e "$help" ;;

        --list|-l)

            local current="►"
            local badDir="✖"
            local name path state

            while read line; do
                name=${line%::*}
                path=${line#*::}
                state=' '
                [ "$PWD" == "$path" ] && state="$current"
                [ ! -d "$path" ] && state="$badDir"
                printf "%1s ${echo_green}%-10s ${echo_cyan}%-60s${echo_normal}\n" \
                    "$state" "$name" "$path"
            done < "$JUMP_BOOKMARKS"
            echo
            ;;

        --add|-a)
            [ -z "$2" ] && { echo -e "$help"; return 0; }
            _jump_bookmark_exists "$2"
            if [ $? -eq 0 ]; then
                echo -e "${echo_yellow}Bookmark exists:${echo_normal}"
                jump --list
                return 0
            else
                echo "$2"'::'"$PWD" >> "$JUMP_BOOKMARKS"
                echo -e "${echo_cyan}Bookmark added${echo_normal}"
            fi
            ;;

        --remove|-r)
            [ -z "$2" ] && { echo -e "$help"; return 0; }
            _jump_bookmark_exists "$2"
            if [ $? -eq 1 ]; then
                echo -e "${echo_yellow}No bookmark with this name:${echo_normal}"
                jump --list
                return 0
            else
                sed -e /^"$2"::/d "$JUMP_BOOKMARKS" > "$JUMP_BOOKMARKS.tmp" && mv "$JUMP_BOOKMARKS.tmp" "$JUMP_BOOKMARKS"
                echo -e "${echo_cyan}Bookmark deleted${echo_normal}"
            fi
            ;;

        --pathfor|-p)
            [ -z "$2" ] && { echo -e "$help"; return 0; }
            _jump_bookmark_exists "$2"
            if [ $? -eq 1 ]; then
                echo -e "${echo_yellow}No bookmark with this name:${echo_normal}"
                jump --list
                return 0
            else
                local bm=$(grep "$2" "$JUMP_BOOKMARKS")
                echo "${bm#*::}"
            fi
            ;;

        *)
            _jump_bookmark_exists "$1"
            if [ $? -eq 0 ]; then
                local bm=$(grep "$1" "$JUMP_BOOKMARKS")
                cd "${bm#*::}"
            else
                echo -e "${echo_yellow}Unable to find '$1'${echo_normal}"
                jump --list
                return 0
            fi
            ;;
    esac

    return 1;
}
