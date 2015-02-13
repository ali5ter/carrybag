cite about-plugin
about-plugin 'CarryBag mathmatical tools'

precision () {

    about 'round off the floating point number to a precision'
    param '1: float'
    param '2: Optional precision'
    param 'If unset, the precision will be 2 decimal places'
    example '$ precision 3.14159'
    example '$ precision 3.14159 4'
    group 'carrybag math tools'

    local p=${2:-2}
    printf "%.${p}f" "$1"
}

max () {

    about 'maximum of the numbers provided'
    param 'list of integer and/or floating point numbers'
    example '$ max 23 55'
    example '$ max 1 3.45 2 233 12'
    group 'carrybag math tools'

    local m=0
    for n in "$@"; do
        m=$(echo -e "if ($m > $n) print \"$m\\n\" else print \"$n\\n\" " | bc -l)
    done
    echo "$m"
}

min () {

    about 'maximum of the numbers provided'
    param 'list of integer and/or floating point numbers'
    example '$ min 23 55'
    example '$ min 1 3.45 2 233 12'
    group 'carrybag math tools'

    local m=$1
    for n in "$@"; do
        m=$(echo -e "if ($m < $n) print \"$m\\n\" else print \"$n\\n\" " | bc -l)
    done
    echo "$m"
}

ave () {

    about 'average of the numbers provided'
    param 'list of integer and/or floating point numbers'
    example '$ ave 23 55'
    example '$ ave 1 3.45 2 233 12'
    group 'carrybag math tools'

    local t=0
    for n in "$@"; do
        t=$(echo "$t+$n" | bc )
    done
    echo "$t/$#" | bc -l
}

d2h () {

    about 'convert base-10 to base-16'
    param '1: decimal number'
    example '$ d2h 254'
    group 'carrybag math tools'

    echo 'obase=16;'"$*" | bc -l
}

h2d () {

    about 'convert base-16 to base-10'
    param '1: hexidecimal number'
    example '$ h2d FE'
    group 'carrybag math tools'

    echo 'obase=10;ibase=16;'"$( echo "$*" | tr 'a-f' 'A-F' )" | bc -l
}

d2b () {

    about 'convert base-10 to base-2'
    param '1: decimal number'
    example '$ d2b 15'
    group 'carrybag math tools'

    echo 'obase=2;'"$*" | bc -l
}

b2d () {

    about 'convert base-2 to base-10'
    param '1: binary number'
    example '$ b2d 1111'
    group 'carrybag math tools'

    echo 'obase=10;ibase=2;'"$*" | bc -l
}

h2b () {

    about 'convert base-16 to base-2'
    param '1: hexidecimal number'
    example '$ b2d E'
    group 'carrybag math tools'

    d2b "$(h2d "$*")"
}

b2h () {

    about 'convert base-2 to base-16'
    param '1: binary number'
    example '$ b2d 1111'
    group 'carrybag math tools'

    d2h "$(b2d "$*")"
}
