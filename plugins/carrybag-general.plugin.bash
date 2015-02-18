cite about-plugin
about-plugin 'CarryBag general tools'

## CarryBag package tools

cb_bootstrap () {

    about 'Re-install CarryBag to create a fresh shell configuration'
    group 'carrybag-admin-tools'

    "$CB_BASE/tools/install.sh"
    reload
}

cb_housekeeping () {

    about 'Clean out typical OS cruft and update installed packages, e.g. brew, npm'
    group 'carrybag-admin-tools'

    source "$CB_BASE/lib/node.bash"
    _update_node_modules

    case "$OSTYPE" in
        darwin*)
            source "$BASH_IT/plugins/available/carrybag-osx.plugin.bash"
            system_maintenance
            source "$CB_BASE/lib/homebrew.bash"
            _update_homebrew_packages
            ;;
        *)
            source "$BASH_IT/plugins/available/carrybag-linux.plugin.bash"
            system_maintenance
            source "$CB_BASE/lib/apt.bash"
            _update_apt_packages
            ;;
    esac
}

cb_3rdparty_update () {

    about 'Pull any new commits for remote 3rdparty git repos used by CarryBag'
    group 'carrybag-admin-tools'

    local _pwd="$PWD"
    echo -e "${echo_cyan}Updating 3rd party packages:${echo_normal}"
    for repo in "$CB_BASE"/3rdparty/*; do
        echo -e "\t${echo_green}$(basename "$repo")${echo_normal}"
        cd "$repo" && git pull
    done
    cd "$_pwd"
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

    find . -print0 | xargs -0 grep -i -C 2 --color=always "$@" 2>/dev/null
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

    fproc "$@" | awk '{print $2}' | xargs kill -9
}

rproc () {

    about 'HUP a set of processes matching the given string'
    param '1: string'
    example '$ rproc http*'
    group 'carrybag-process-tools'

    fproc "$@" | awk '{print $2}' | xargs kill -HUP
}

## Connectivity tools

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

    local delay=0
    local int=false
    [ $# -gt 1 ] && { delay=$1; shift; }
    trap "int=true" INT
    while ! $int; do "$@"; sleep "$delay" || int=true; done
}

mondir () {

    about 'execute a command if a file changes or is added in the current directory'
    param '1: optional cycle time in seconds'
    param 'if unset, then 2 seconds is used'
    param '2: command'
    param 'if an alias is messign with your command then prepend it with a backslash'
    example '$ mondir build.sh'
    example '$ mondir 10 build.sh'
    group 'carrybag-file-tools'

    rm -f /tmp/"${TMPFILE_TMPL//[X]}"*
    local last=$(mktemp "/tmp/$TMPFILE_TMPL")
    local delay=2
    local diff=''
    local int=false
    [ $# -gt 1 ] && { delay=$1; shift; }
    touch "$last"
    echo; echo "$(color white blue)Monitoring $(pwd) for file changes and additions every $delay seconds...$(color)"
    trap "int=true" INT
    sleep "$delay"
    while ! $int; do
        diff=$(find . -newer "$last" -type f  | grep -v ".DS_Store\|.svn\|.git\|.vim/backup")
        [ "$(echo "$diff" | grep -c './')" -gt '0' ] && {
            touch "$last"
            echo
            echo "$(color black green)Files changed at $(date):$(color)"
            echo "$(color white green)$diff$(color)"
            echo
            echo "$(color black blue)Triggering command...$(color)"
            eval "$@" && echo "$(color black blue)Done$(color)"
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

#
# @usage pbar [current] [total] [length] ... ascii progress bar
#

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
