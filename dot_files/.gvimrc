"
" @file gvimrc
" Custom mac vim settings
" @author Alister Lewis-Bowen <alister@different.com>
"

"
" Set the font (https://github.com/b4winckler/macvim/wiki/FAQ)
"

set guifont=Monaco:h14

"
" Set the default size of the window
"

set lines=48
set columns=120

"
" Hide the toolbar
"

set guioptions-=T

"
" Set color scheme (https://github.com/altercation/vim-colors-solarized)
"

syntax enable
colorscheme solarized
"if has('gui_running')
"    set background=light
"else
    set background=dark
"endif
