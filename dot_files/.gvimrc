" @file gvimrc
" @brief  Custom gui vim settings
" @author Alister Lewis-Bowen <alister@different.com>

"
" General
"
"

set guifont=Monaco:h14 " particularly OSX
set lines=48 " height
set columns=120 " width
set guioptions-=T " hide the toolbar

"
" Colors
" ● https://github.com/altercation/vim-colors-solarized)
"

syntax enable
colorscheme solarized
set background=dark

"
" Mappings
"

nmap <c-tab> :tabnext<cr> " cntl-tab cycle forward through tabs
imap <c-tab> <c-o>:tabnext<cr>
vmap <c-tab> <c-o>:tabnext<cr>
nmap <c-s-tab> :tabprevious<cr> " cntl-shift-tab cycle back through tabs
imap <c-s-tab> <c-o>:tabprevious<cr>
vmap <c-s-tab> <c-o>:tabprevious<cr>

