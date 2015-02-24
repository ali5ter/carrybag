#!/usr/bin/env bash
# vim configuation delivered by CarryBag

set -e

export VIMRC=~/.vimrc
export VIM_DIR=~/.vim
export VIM_BUNDLE="$VIM_DIR/bundle"

_install_vim_bundle () {

    local repo="$*"
    local clone

    case "$OSTYPE" in
        darwin*)    clone=3rdparty/$(basename -s .git "$repo") ;;
        *)          clone=3rdparty/$(basename "$repo" .git) ;;
    esac

    git submodule status | grep -q "$clone" ||
        git submodule add "$repo" "$clone"

    cp -r "$clone" "$VIM_BUNDLE/"
}

_install_pathogen () {

    _install_vim_bundle https://github.com/tpope/vim-pathogen.git

    mkdir -p "$VIM_DIR/autoload" "$VIM_BUNDLE" &&
        cp "3rdparty/vim-pathogen/autoload/pathogen.vim" "$VIM_DIR/autoload/"

    cat <<PATHOGEN >> "$VIMRC"

"
" Pathogen
"
execute pathogen#infect()
PATHOGEN
}

_install_solarized () {

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

_install_ctrlp () {

    _install_vim_bundle https://github.com/kien/ctrlp.vim.git

    cat <<CTRLP >> "$VIMRC"

"
" CtrlP
"
nmap <leader>p :CtrlP<cr>
CTRLP
}

_install_powerline_fonts_osx () {

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

    echo -e "${echo_green}Edit the OSX Terminal preferences to change to a Powerline font.$echo_normal"
}

_install_powerline_fonts_linux () {

    local _dir='/usr/share/fonts/opentype'
    local _file

    echo -e "${echo_cyan}Installing Powerline fonts:$echo_normal"

    [ -e "$_dir" ] || sudo mkdir -p "$_dir"

    while IFS= read -d $'\0' -r font; do
        _file="$(basename "$(echo "$font" | tr ' ' '_')")"
        echo -e "\t${echo_green}$(basename -s .otf "$font")$echo_normal"
        sudo cp "$font" "$_dir/$_file"
    done < <(find 3rdparty/fonts -name "*.otf" -print0)

    sudo fc-cache -f

    echo -e "${echo_green}Edit the Terminal profile to change to a Powerline font.$echo_normal"
}

_install_vimairline () {

    _install_vim_bundle https://github.com/bling/vim-airline.git

    echo -ne "${echo_yellow}Want to install Powerline fonts to use with Airline? [y/N] ${echo_normal}"
    read -n 1 reply
    case "$reply" in
        Y|y)
            _install_vim_bundle https://github.com/powerline/fonts.git
            case "$OSTYPE" in
                darwin*)    _install_powerline_fonts_osx ;;
                *)          _install_powerline_fonts_linux ;;
            esac
            ;;
    esac

    cat <<AIRLINE >> "$VIMRC"

"
" Airline
"
let g:airline_powerline_fonts = 1           " use powerline fonts if available
let g:airline#extensions#tabline#enabled = 1    " enable tabline to show buffers
let g:airline#extensions#tabline#fnamemod = ':t'" just show filename for buffer
AIRLINE
}

_install_syntastic () {

    _install_vim_bundle https://github.com/scrooloose/syntastic.git

    cat <<SYNTASTIC >> "$VIMRC"

"
" Syntastic
"
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_loc_list_height = 5

let g:syntastic_error_symbol = "✗"
let g:syntastic_warning_symbol = "⚠"
let g:syntastic_style_error_symbol = "✗"
let g:syntastic_style_warning_symbol = "⚠"

let g:syntastic_filetype_map = {
    \ "bash": "sh",
    \ "plist": "xml" }
SYNTASTIC
}

_install_syntax_highlighters () {

    _install_vim_bundle https://github.com/tpope/vim-markdown.git
    _install_vim_bundle https://github.com/jelera/vim-javascript-syntax.git
    _install_vim_bundle https://github.com/othree/javascript-libraries-syntax.vim.git
    _install_vim_bundle https://github.com/othree/html5.vim.git
    _install_vim_bundle https://github.com/hail2u/vim-css3-syntax.git
    _install_vim_bundle https://github.com/elzr/vim-json.git
    _install_vim_bundle https://github.com/StanAngeloff/php.vim.git
    _install_vim_bundle https://github.com/vim-perl/vim-perl.git

    cat <<SYNTAX >> "$VIMRC"
"
" Javascript-libraries-syntax
"
autocmd BufReadPre *.js let b:javascript_lib_use_jquery = 1
autocmd BufReadPre *.js let b:javascript_lib_use_angularjs = 0
SYNTAX
}

_build_carrybag_vim_config () {

    ## Back up any existing vim files
    for file in "$VIMRC" "$VIM_DIR"; do
        [ -w "$file" ] && cp -r "$file" "$file.bak" && rm -fR "$file" &&
            echo -e "${echo_cyan}Your $(basename $file) has been backed up to $file.bak$echo_normal"
    done

    ## Set up the vim runcom
    cp "$CB_BASE/templates/vimrc.template" "$VIMRC"

    ## Create a backup dir for any vim swap cruft
    mkdir -p "$VIM_DIR/backup"

    ## Install pathogen for vim pacakge management
    _install_pathogen
    echo -e "${echo_cyan}Pathogen installed to manage addons to vim${echo_normal}"

    ## Install vim packages
    _install_solarized
    echo -e "${echo_cyan}Solarize color theme added to vim${echo_normal}"
    #_install_nerdtree
    #echo -e "${echo_cyan}NERDTree added to vim${echo_normal}"
    _install_vimairline
    echo -e "${echo_cyan}Airline added to vim${echo_normal}"
    _install_ctrlp
    echo -e "${echo_cyan}CtrlP added to vim${echo_normal}"
    _install_syntastic
    echo -e "${echo_cyan}Syntastic added to vim${echo_normal}"
    _install_syntax_highlighters
    echo -e "${echo_cyan}Syntax highlighters added to vim${echo_normal}"
}
