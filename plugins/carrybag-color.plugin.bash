cite about-plugin
about-plugin 'CarryBag color tools'

hex2rgb () {

    about 'convert hex color to rgb'
    param '1: hex color'
    example '$ hex2rgb ffcc22'
    group 'carrybag color tools'

    local hex=$(echo "$1" | tr '[:lower:]' '[:upper:]')
    local r=$(echo "ibase=16; $(echo "$hex" | cut -c -2)" | bc -l)
    local g=$(echo "ibase=16; $(echo "$hex" | cut -c 3-4)" | bc -l)
    local b=$(echo "ibase=16; $(echo "$hex" | cut -c 5-6)" | bc -l)
    echo "($r, $g, $b)"
}

rgb2hex () {

    about 'convert rgb color to hex'
    param '1: rbg color'
    example '$ rgb2hex 255 204 34'
    group 'carrybag color tools'

    local hex=$(python -c "print '#%02x%02x%02x' % (${1:-0}, ${2:-0}, ${3:-0})")
    echo -n "$hex" | pbcopy
    echo "$hex"
}

rgb2hsl () {

    about 'convert rgb color to hsl'
    param '1: rbg color'
    example '$ rgb2hex 255 204 34'
    group 'carrybag color tools'

    local r=$(echo "$1/255" | bc -l)
    local g=$(echo "$2/255" | bc -l)
    local b=$(echo "$3/255" | bc -l)
    local _min=$(min "$r" "$g" "$b")
    local _max=$(max "$r" "$g" "$b")
    local delta=$(echo "$_max-$_min" | bc -l)
    local deltaR=0
    local deltaG=0
    local deltaB=0
    local h=0
    local s=0
    local l=$(echo "($_max+$_min) / 2" | bc -l)
    [ "$(echo "if ($delta!=0) 1 else 0" | bc -l)" -eq '1' ] && {
        s=$(echo "if ($l<0.5) $delta/($_max+$_min) else $delta/(2-$_max-$_min)" | bc -l)
        deltaR=$(echo "((($_max-$r)/6)+($delta/2))/$delta" | bc -l)
        deltaG=$(echo "((($_max-$g)/6)+($delta/2))/$delta" | bc -l)
        deltaB=$(echo "((($_max-$b)/6)+($delta/2))/$delta" | bc -l)
        if [ "$(echo "if ($r==$_max) 1 else 0" | bc -l)" -eq '1' ]; then
            h=$(echo "$deltaB-$deltaG" | bc -l)
        elif [ "$(echo "if ($g==$_max) 1 else 0" | bc -l)" -eq '1' ]; then
            h=$(echo "(1/3)+$deltaR-$deltaB" | bc -l)
        elif [ "$(echo "if ($b==$_max) 1 else 0" | bc -l)" -eq '1' ]; then
            h=$(echo "(2/3)+$deltaG-$deltaR" | bc -l)
        fi
        h=$(echo "if ($h<0) $h+1 else $h" | bc -l)
        h=$(echo "if ($h>1) $h-1 else $h" | bc -l)
    }
    local hDegrees=$(echo "360*$h" | bc -l)
    local sPercent=$(echo "100*$s" | bc -l)
    local lPercent=$(echo "100*$l" | bc -l)
    echo "$(precision "$hDegrees" 0)"'° '"$(precision "$sPercent" 0)"'% '"$(precision "$lPercent" 0)"'%'
    echo "($(precision "$h"), $(precision "$s"), $(precision "$l"))"
}
