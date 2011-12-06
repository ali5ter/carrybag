" @file vimrc
" Alister's custom vim settings
" ref: http://www.vi-improved.org/vimrc.php

set nocompatible " explicitly get out of vi-compatible mode
set noexrc " don't use local version of .(g)vimrc, .exrc
set background=dark " we plan to use a dark background
syntax on

"set cursorcolumn " highlight the current column
"set cursorline " highlight current line
set nohlsearch " do not highlight searched for phrases
set number " turn on line numbers
set numberwidth=5 " We are good up to 99999 lines
set ruler " Always show current positions along the bottom
set list " we do what to show tabs, to ensure we get them out of my files
set listchars=tab:>-,trail:- " show tabs and trailing 

set nowrap " do not wrap line
set tabstop=4 "set tab character to 4 characters
set expandtab "turn tabs into whitespace

syntax enable
set t_Co=16
let g:solarized_termcolors=16
colorscheme solarized

set laststatus=2
