# CarryBag library fhnctions for the LLDB runcom configurations

_cblib_lldb=1

LLDBINIT=~/.lldbinit
LLDBINIT_ADD_TOKEN="## Created by $0"

add_to_lldbinit () {

    local text="$*"

    sed -e "/$LLDBINIT_ADD_TOKEN/a\\
$text" "$LLDBINIT" > "$LLDBINIT.tmp" && mv "$LLDBINIT.tmp" "$LLDBINIT"

    return 0
}

build_carrybag_lldbinit () {

    ## Use template
    [ -w "$LLDBINIT" ] && cp "$LLDBINIT" "$LLDBINIT.bak" &&
        echo -e "${echo_cyan}Your $(basename "$LLDBINIT") has been backed up to $LLDBINIT.bak${echo_normal}"
    cp "$CB_BASE/templates/lldbinit.template" "$LLDBINIT"

    return 0
}
