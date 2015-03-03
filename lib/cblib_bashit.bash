# CarryBag library functions for working with bash-it

_cblib_bashit=1

preload_carrybag_themes () {

    echo -e "${echo_cyan}Copy CarryBag themes to Bash It:${echo_normal}"

    for file in $CB_BASE/themes/*; do
        _file=$(basename "$file")
        [ "$_file" == '*' ] || {
            echo -e "\t${echo_green}$_file${echo_normal}"
            [ -e "$BASH_IT/themes/$_file" ] && rm -fR "$BASH_IT/themes/$_file"
            cp -r "$file" "$BASH_IT/themes/$_file"
        }
    done

    return 0
}

preload_carrybag_addons () {

    echo -e "${echo_cyan}Copy CarryBag addons to Bash It:${echo_normal}"

    for ftype in "aliases" "completion" "plugins"; do
        for file in $CB_BASE/$ftype/*; do
            _file=$(basename "$file")
            [ "$_file" == '*' ] || {
                echo -e "\t${echo_cyan}$ftype ${echo_green}$(echo "$_file" | cut -d'.' -f 1)${echo_normal}"
                [ -e "$BASH_IT/available/$_file" ] && rm -f "$BASH_IT/available/$_file"
                cp "$file" "$BASH_IT/$ftype/available/$_file"
            }
        done
    done

    return 0
}

bash-it-enable () {

    local type=$1
    local addon=$2

    bash-it enable "$type" "$addon" >/dev/null &&
        echo -e "\t${echo_cyan}$type ${echo_green}$addon${echo_normal}"

    return 0
}
