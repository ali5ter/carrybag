cite about-plugin
about-plugin 'CarryBag general tools'

_cblib_general=1

## CarryBag package tools

cb_bootstrap () {

    about 'Re-install CarryBag to create a fresh shell configuration'
    group 'carrybag-admin-tools'

    eval "$CB_BASE/tools/install.sh --update --quiet"
    return 0
}

cb_housekeeping () {

    about 'Clean out typical OS cruft and update installed packages, e.g. brew, npm'
    group 'carrybag-admin-tools'

    case "$OSTYPE" in
        darwin*)
            [ -z "$_cblib_osx" ] && source carrybag-osx.plugin.bash
            system_maintenance
            [ -z "$_cblib_homebrew" ] && source cblib_homebrew.bash
            update_homebrew_packages
            [ -z "$_cblib_cask" ] && source cblib_cask.bash
            update_cask
            ;;
        *)
            [ -z "$_cblib_linux" ] && source carrybag-linux.plugin.bash
            system_maintenance
            [ -z "$_cblib_apt" ] && source cblib_apt.bash
            update_apt_packages
            ;;
    esac

    [ -z "$_cblib_node" ] && source cblib_node.bash
    update_node_modules

    echo -e "${echo_green}You might want to run ${echo_white}bootstrap${echo_green} to include any updates${echo_normal}"
    return 0
}

cb_3rdparty_update () {

    about 'Pull any new commits for remote 3rdparty git repos used by CarryBag'
    group 'carrybag-admin-tools'

    local _pwd="$PWD"
    echo -e "${echo_cyan}Updating 3rd party packages:${echo_normal}"
    shopt -u dotglob
    for repo in "$CB_BASE"/3rdparty/*; do
        echo -e "\t${echo_green}$(basename "$repo")${echo_normal}"
        cd "$repo" && git pull origin master
    done
    shopt -s dotglob
    cd "$_pwd"
    return 0
}

## Find tools

ffile () {

    about 'find a file form this drectory down'
    param '1: file'
    example '$ ffile index*.htm*'
    group 'carrybag-find-tools'

    find . | grep -i --color=always "$@" 2>/dev/null
}

ftext () {

    about 'find text in files from this directory down'
    param '1: text'
    example '$ ffile var i=30'
    group 'carrybag-find-tools'

    find . -print0 | xargs -0 grep -i -n -C 2 --color=always "$@" 2>/dev/null
}

mktmpdir () {

    about 'create and return the name of a temp directory'
    example '$ MY_TMP_DIR="$(mktmpdir)"'
    group 'carrybag-find-tools'

    mktemp -d 2>/dev/null || mktemp -d -t ''
}

## Help tools

bman () {

    about 'find bash help for a built-in command'
    param '1: command'
    example '$ fstart set'
    group 'carrybag-help-tools'

    man bash | less -p "^       $1 "
}

## Process tools

fproc () {

    about 'find a process matching the given string'
    param '1: string'
    example '$ fproc http*'
    group 'carrybag-process-tools'

    pgrep -lf "$@"
}

kproc () {

    about 'kill a set of precesses matching the given string'
    param '1: string'
    example '$ kproc http*'
    group 'carrybag-process-tools'

    fproc "$@" | awk '{print $1}' | xargs kill -9
}

rproc () {

    about 'HUP a set of processes matching the given string'
    param '1: string'
    example '$ rproc http*'
    group 'carrybag-process-tools'

    fproc "$@" | awk '{print $2}' | xargs kill -HUP
}

## Connectivity tools

ports () {
    case "$OSTYPE" in
        darwin*)
            sudo lsof -i -P | grep -i "listen"
            ;;
        *)
            sudo nmap -T Aggressive -A -v 127.0.0.1 -p 1-65000
            sudo netstat --tcp --udp --listening --program
            ;;
    esac
}

webserv () {

    about 'start httpd using the current directory as the document root'
    param '1: optional IP address'
    param 'if unset, defaults to 127.0.0.1'
    param '2: optional port'
    param 'if unset, defaults to 8000'
    example '$ webserv'
    example '$ webserv 192.168.100.10'
    example '$ webserv 192.168.100.10 8080'
    group 'carrybag-connectivity-tools'

    kproc http-server
    # display autoindex and include 'Access-Control-Allow-Origin' in response header
    http-server -i --cors -a "${1-'127.0.0.1'}" -p "${2-'8000'}"
}

sshkey () {

    about 'display public RSA key or create ssh keys if none found'
    group 'carrybag-connectivity-tools'

    if [ -e ~/.ssh/id_rsa.pub ]; then
        cat ~/.ssh/id_rsa.pub
    else
        local answer
        echo -ne "${yellow}You don't have a public key. Want to create one? [y/N]: ${echo_normal}";
        read -n 1 reply
        case "$reply" in
            Y|y)
                command -v ssh-keygen >/dev/null || {
                    echo -e >&2 "${echo_orange}ssh-keygen is not installed.${echo_normal}";
                    exit 1;
                }
                ssh-keygen -t rsa -C "${USER}@${HOSTNAME}"
                ;;
            N|n)    echo ;;
        esac
    fi
}

## File tools

fstart () {

    about 'show first 100 lines of a given file'
    param '1: file'
    example '$ fstart access.log'
    group 'carrybag-file-tools'

    head -n100 "$1"
}

fend () {

    about 'show last 100 lines of a given file'
    param '1: file'
    example '$ fend access.log'
    group 'carrybag-file-tools'

    tail -n100 "$@"
}

rotate () {

    about 'typical rotate backup command up to a max of 30 versions'
    param '1: file'
    example '$ rotate access.log'
    group 'carrybag-file-tools'

    local _file=$1
    local _max="30"
    [ -f "$_file" ] && {
        while [ $_max -gt 0 ]; do
            [ -f "$_file".$((_max-1)) ] && mv "$_file".$((_max-1)) "$_file".$_max
            ((_max--))
        done
        mv "$_file" "$_file".0
    }
    cat /dev/null > "$_file"
}

watch () {

    about 'execute a command periodically'
    param '1: optional cycle time in seconds'
    param 'if unset, the shortest time is used'
    param '2: command'
    param 'if an alias is messign with your command then prepend it with a backslash'
    example '$ watch \ls -1 | wc -l'
    example '$ watch 10 \ls -1 | wc -l'
    group 'carrybag-file-tools'

    local int=false

    local delay=0
    [ $# -gt 1 ] && { delay=$1; shift; }

    trap "int=true" INT

    while ! $int; do (eval "$@"); sleep "$delay" || int=true; done
}

mondir () {

    about 'execute a command if a file changes or is added in the current directory'
    param '1: optional cycle time in seconds'
    param 'if unset, then 10 seconds is used'
    param '2: command'
    param 'if an alias is messign with your command then prepend it with a backslash'
    example '$ mondir build.sh'
    example '$ mondir 10 build.sh'
    group 'carrybag-file-tools'

    local diff=''
    local int=false
    local pre="${echo_white}${echo_background_purple} mondir: "
    local post=" ${echo_normal}"
    local exclusions='\.DS_Store|\.svn|\.git|\.vim/backup|\.log'

    local delay=2
    [ $# -gt 1 ] && { delay=$1; shift; }

    ttmplt=.mondir-XXXXXXXXXX
    rm -f /tmp/"${ttmplt//[X]}"*
    local last=$(mktemp "/tmp/$ttmplt")
    touch "$last"

    echo -e "${pre}Started${post}"

    trap "int=true" INT

    sleep "$delay"

    while ! $int; do
        diff=$(find . -newer "$last" -type f 2>/dev/null | egrep -v "$exclusions")
        [ "$(echo "$diff" | grep -c './')" -gt '0' ] && {
            touch "$last"
            echo -e "\n${pre}Files changed at $(date):${post}"
            for file in $diff; do echo -e "${pre}\t${file}${post}"; done
            echo -e "${pre}Executing '$*' command${post}"
            (eval "$@") && echo -e "\n${pre}'$*' command complete${post}"
        }
        sleep "$delay" || int=true
    done
}

mvln () {

    about 'move a file then link it back to the original location'
    param '1: source file'
    param '2: target directory'
    example '$ mvln .runcom ~/dot_files'
    group 'carrybag-file-tools'

    rm -f /tmp/"${TMPFILE_TMPL//[X]}"*
    local _source=$1
    local _target=$2
    local _file=$(basename "$_source")
    [ -f "$_target/$_file" ] && rotate "$_target/$_file"
    mv "$_source" "$_target"
    ln -sf "$_target/$_file" "$_source"
}

cfn () {

    about 'normalize a filename'
    param '1: file'
    example '$ cfn "This is a File"'
    group 'carrybag-file-tools'

    local file="$*"
    mv -v "$file" "$(echo "$file" | tr ' ' '_' | tr -d '{}(),\!' | \
        tr -d "\'" | tr '[:upper:]' '[:lower:]' | sed 's/_-_/_/g')"
}

## User Interface tools

ftree () {

    about 'textual file tree'
    group 'carrybag-ui-tools'

    find . -type d | grep -v .git | \
        sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/ /' -e 's/-/|/'
}

pbar () {

    about 'textual progress bar'
    param '1: Optional current value'
    param 'If unset, is set to 0'
    param '2: Optional maximum value'
    param 'If unset, is set to 100'
    param '3: Optional bar length'
    param 'If unset, is set to 70'
    example '$ progress'
    example '$ progress 35'
    example '$ progress 35 321'
    example '$ progress 35 321 40'
    group 'carrybag-ui-tools'

    local current=${1:-0}
    local total=${2:-100}
    local length=${3:-70}
    local completed=$(printf '%.0f' "$(echo "scale=2; ($current/$total)*$length" | bc -l)")
    printf '\r %2.0f%% [' "$(echo "scale=2; $current*100/$total" | bc -l)"
    head -c $((completed+1)) /dev/zero | tr '\0' '='
    head -c $((length-completed)) /dev/zero | tr '\0' '-'
    echo -n ']'
    head -c $((length-completed+1)) /dev/zero | tr '\0' '\b'
}

graph () {

    about 'textual graph with average line as wide as the number of data points'
    param '1: Number defining the height of the graph'
    param '2:n Numbers defining the data points'
    example '$ graph 10 2.2 2 2.2 2.23 2.4 3.1 4.5 5.8 7 8.9'
    group 'carrybag-ui-tools'
    ## @see Taken from http://bashscripts.org/forum/viewtopic.php?f=7&t=1141

    height=$1; shift;

    echo "$@" | awk -v height="$height" 'BEGIN { }
    ## convert big numbers to short kilo/mega/giga etc numbers
    function pow1k(bignum) {
        metric=1;
        num=bignum;

        # devide by 1000 until we have got a small enough number
        while (num>=1000) { metric++; num/=1000; }
        num=int(num);

        # get SI prefix (kilo, mega, giga, tera, peta, exa, zotta, yotta)
        si=substr(" KMGTPEZY", metric, 1);

        # get a division remainder to total our number of characters to a maximum of 4
        division=substr(bignum, length(num)+1, 3-length(num));

        # right align the output
        str=sprintf("%s%c%s", num, si, division);
        return(sprintf("% 4s", str));
    }
    {
        # get smallest, largest and total of all numbers
        min=max=tot=$1;
        for (x=2; x<=NF; x++) { tot+=$x; if ($x>max) max=$x; if ($x<min) min=$x; }

        # the difference between largest and smallest number is out working area
        diff=max-min;
        if (diff==0) diff=1;                                # all numbers are the same?!
        # some fancy math to get the average of all numbers
        avg=(tot/NF);
        avgfull=int(((avg-min)*height/diff));               # average full
        avghalf=int(((avg-min)*height/diff)%1+0.5);         # average half

        # fill arrays bars
        for (x=1; x<=NF; x++) {
            v=$x-min;                                       # our value
            i=0;array[x]="";                                # blank the array
            full=int((v*height/diff));                      # how many full?
            ttrd=int((v*height/diff)%1+0.333);              # 2/3rd full?
            otrd=int((v*height/diff)%1+0.666);              # 1/3rd full?
            while (i<full)   { array[x]=array[x]"O"; i++; } # fill all fulls
            if    (ttrd>0)   { array[x]=array[x]"o"; i++; } # fill 2/3rd
            else if (otrd>0) { array[x]=array[x]"."; i++; } # or 1/3rd

            # average line or blank
            while (i<height) {                              # fill to the top
                if (i==avgfull)                             # with average line
                    if (avghalf>0) array[x]=array[x]"-";
                    else array[x]=array[x]"_";
                else array[x]=array[x]" ";                  # or mostly blanks
                i++;
            }
        }

        # display output
        for (y=height; y>0; y--) {
            line=""; num="    ";                            # blank line and number
            if (y==avgfull+1) { num=pow1k(int(avg)); }      # show average number
            if (y==height)    { num=pow1k(max); }           # show maximum number
            if (y==1)         { num=pow1k(min); }           # show minimum number

            for (x=1; x<=NF; x++)                           # do for all data values
                line=line""substr(array[x],y,1);            # create line from arrays
            printf(" %s | %s | %s\n", num, line, num);      # display 1 line
        }
    }'
}
