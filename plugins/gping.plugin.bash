cite about-plugin
about-plugin 'utility to create a textual graph of ICMP response times'

_cblib_gping=1

_gp_init () {

    ping "$GP_HOST" > "$GP_METRICS" 2>/dev/null &
    for i in $(seq "$GP_WIDTH"); do echo -n '0 ' >> "$GP_DATA"; done
}

_gp_start () {
    local metric    # line of ping output
    local data      # temp store for data

    int=false

    while ! $int; do
        metric=$(tail -n1 "$GP_METRICS")
        [ "$(echo "$metric" | grep timeout -c)" -eq '0' ] && {
            GP_LAST_MTIME=$(echo "$metric" | grep time= | perl -lpe's/.*time=(.*) ms.*/\1/g')
            [ -z "$GP_LAST_MTIME" ] && GP_LAST_MTIME=0
            data=$(cat "$GP_DATA")
            echo "$data $GP_LAST_MTIME" | cut -d' ' -f2-"$GP_WIDTH" > "$GP_DATA"
        }
        _gp_graph_it
        sleep 1 || int=true
    done
}

_gp_graph_it () {

    clear
    echo -e "${echo_yellow}"
    graph "$GP_HEIGHT" "$(cat "$GP_DATA")"
    echo -ne "\n\t${echo_cyan}Response from ${echo_white}$GP_HOST${echo_cyan} "
    echo -ne "in milliseconds: $GP_LAST_MTIME${echo_normal}"
}

_gp_finish () {
    rm -f "$GP_METRICS" "$GP_DATA"
}

trap "int=true" INT

gping () {

    about 'textual graph of ICMP response times'
    param '1: Optional domain. Defaults to google.com'
    param '2: Optional graph height. Defaults to 10'
    param '3: Optional graph width. Defaults to 79'
    example '$ gping'
    example '$ gping different.com'
    example '$ gping different.com 24'
    example '$ gping different.com 24 55'
    group 'carrybag-ui-tools'

    [ -z "$_cblib_general" ] && source carrybag-general.plugin.bash

    GP_HOST=${1:-localhost}         # default host
    GP_HEIGHT=${2:-$((LINES-4))}    # graph height
    GP_WIDTH=${3:-$((COLUMNS-16))}  # graph width

    GP_DIR=$(mktmpdir)
    GP_METRICS="$GP_DIR/metrics"  # output file of ping results
    GP_DATA="$GP_DIR/data"        # data store
    GP_LAST_MTIME=0               # last icmp time

    _gp_init
    _gp_start
    _gp_finish
}
