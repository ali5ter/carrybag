cite about-plugin
about-plugin 'Carrybag ctag tools'

ctags --version | grep Exuberant >/dev/null || \
    echo -e "${echo_yellow}Please install Exuberant Ctags.${echo_normal}"

# @see http://tbaggery.com/2011/08/08/effortless-ctags-with-git.html
gctags () {
    set -x
    about 'run ctags within a git repo'
    group 'carrybag-ctag-tools'

    local dir="$(git rev-parse --git-dir)"
    local tags="$dir/$$.tags"

    [ -d "$dir" ] && {
        trap 'rm -f "$tags"' EXIT

        git ls-files | ctags --tag-relative -L - -f"$tags"
        mv "$tags" "$dir/tags"
    }
    set +x
}
