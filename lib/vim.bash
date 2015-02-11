#!/usr/bin/env bash
# vim configuation delivered by CarryBag

set -e

export VIMRC=~/.vimrc
export VIM_DIR=~/.vim
export VIM_BUNDLE="$VIM_DIR/bundle"

_install_vim_bundle () {
    local repo="$@"
    local clone=3rdparty/$(basename -s .git "$repo")
    [ "$(git submodule status | grep -c $clone)" -eq "0" ] &&
        git submodule add "$repo" "$clone"
    cp -r "$clone" "$VIM_BUNDLE/"
}

_install_pathogen () {
    mkdir -p "$VIM_DIR/autoload" "$VIM_BUNDLE" &&
        curl -LSso "$VIM_DIR/autoload/pathogen.vim" https://tpo.pe/pathogen.vim
    cat <<PATHOGEN >> "$VIMRC"

"
" Pathogen
"
execute pathogen#infect()
PATHOGEN
}

_install_solarized () {
    ## Install solarized color scheme
    _install_vim_bundle https://github.com/altercation/vim-colors-solarized.git
    cat <<SOLARIZED >> "$VIMRC"

"
" Solarized color scheme
"
syntax enable
set background=dark
set t_Co=256
colorscheme solarized
SOLARIZED
}

_install_nerdtree () {
    ## Install NERDTree
    _install_vim_bundle https://github.com/scrooloose/nerdtree.git
    cat <<NERDTREE >> "$VIMRC"

"
" NERDTree
"
let NERDTreeShowHidden=1
let NERDTreeShowBookmarks=1
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
NERDTREE
}

_install_vimairline () {
    _install_vim_bundle https://github.com/bling/vim-airline.git
    _install_vim_bundle https://github.com/powerline/fonts.git
    [[ $OSTYPE == darwin* ]] && {
        ## TODO: System Preferences > Security & Privacy > Privacy > Accessibility
        ##       for the Terminal app
        echo -e "${echo_cyan}Installing Powerline fonts:$echo_normal"
        while IFS= read -d $'\0' -r font; do
            [[ $font == *SourceCodePro/Sauce\ Code\ Powerline\ Light* ]] && {
                echo -e "\t${echo_green}$(basename -s .otf "$font")$echo_normal"
                ## TODO: AppleScript still flakey - times out
                osascript <<INSTALLPOWERLINEFONT
set theFontPath to "$CB_BASE/$font"
set theFont to POSIX file theFontPath

tell application "Finder" to open theFont

tell application "Font Book"
    activate
    open theFont
    if exists window 1 then
        tell application "System Events" to tell process "Font Book"
            click button "Install Font" of group 1 of window 1
        end tell
    end if
    if exists window 1 then
        tell application "System Events" to tell process "Font Book"
            click button 1 of window 1
        end tell
    end if
end tell

tell application "Font Book" to quit
INSTALLPOWERLINEFONT
            }
        done < <(find 3rdparty/fonts -name "*.otf" -print0)
        echo -e "${echo_green}Change the font of your terminal app to use one of these fonts.$echo_normal"
    }
    cat <<AIRLINE >> "$VIMRC"

"
" Airline
"
let g:airline_powerline_fonts = 1
AIRLINE
}

_build_vim_config() {

    ## Back up any existing vim files 
    for file in "$VIMRC" "$VIM_DIR"; do
        [ -w "$file" ] && cp -r "$file" "$file.bak" &&
            echo -e "${echo_cyan}Your $(basename $file) has been backed up to $file.bak$echo_normal"
    done

    ## Set up the vim runcom
    cp "$CB_BASE/templates/vimrc.template.bash" "$VIMRC"


    ## Create a backup dir for any vim swap cruft
    mkdir -p "$VIM_DIR/backup"

    ## Install pathogen for vim pacakge management
    _install_pathogen

    ## Install vim packages
    _install_solarized
    _install_nerdtree
    _install_vimairline
}
