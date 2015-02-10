" vim configuration dilivered by CarryBag

"
" General
"
set nocompatible " enable advanced features
set noexrc " don't use local version of .(g)vimrc, .exrc
set noswapfile " stop leaving .swp files around
set backup " make backup files
set backupdir=~/.vim/backup " dir for backup files
set noerrorbells " make silent
set nostartofline " try to stay in same column when scrolling

"
" Formatting
"
set nowrap " do not wrap line
set shiftwidth=4 " set shift (>>) to 4 spaces
set autoindent " turn on auto indentation
set smartindent " smarter auto indentation
set cindent " really smart auto indentation
set tabstop=4 " set tab character to 4 characters
set expandtab " turn tabs into whitespace
set nosmarttab " no tabs
"set textwidth=80 " wrap at 80 chars

"
" Folding
"
"set nofoldenable " disable folding
"set foldmethod=syntax " folds based on syntax
"set foldlevelstart=1 " start folding at 1st level
"let javaScript_fold=1
"let perl_fold=1
"let php_folding=1
"let r_syntax_folding=1
"let ruby_fold=1
"let sh_fold_enabled=1
"let vimsyn_folding='af'
"let xml_syntax_folding=1
set foldmethod=indent " folds based on indents
set foldnestmax=2 " only fold 2 levels deep
set foldlevelstart=3 " start folding at 3rd level
"autocmd Syntax htm,html,xhtml setlocal foldmethod=indent
"autocmd Syntax htm,html,xhtml normal zR

"
" Visuals
"
set rtp+=~/bin/powerline/bindings/vim
set laststatus=2 " always show status line
set visualbell " no flashing
set wildmenu " turn on command completion
set wildmode=list:longest,full " list all possible completions
set noshowcmd " don't show partial commands
set nolazyredraw " tuen off lazy menu
set showmatch " show matching braces
set incsearch " show search as you type
set ignorecase " ignore case when searching
set nohlsearch " highlight searched for phrases
set number " turn on line numbers
set numberwidth=5 " width for up to 99999 lines
set ruler "show current cursor position
"set cursorcolumn " highlight the current column
"set cursorline " highlight current line
set list " show hidden characters
set listchars=tab:▸\ ,trail:- " show tabs and trailing
" show column 80 as a width guide...
if exists('+colorcolumn')
    set colorcolumn=80
else
    au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

"
" Map extensions to existing syntax highlighters
"
autocmd BufNewFile,BufRead *.module set filetype=php
autocmd BufNewFile,BufRead *.mxml set filetype=xml
autocmd BufNewFile,BufRead *.as set filetype=javascript
autocmd BufNewFile,BufRead *.json set filetype=javascript
autocmd BufNewFile,BufRead *.pde set filetype=arduino
autocmd BufNewFile,BufRead *.ino set filetype=arduino

"
" Text expansions
"
abbreviate lorem Lorem<space>ipsum<space>dolor<space>sit<space>amet,<space>consectetuer<space>adipiscing<space>elit.<space>Ut<space>ultrices.<space>Phasellus<space>lectus<space>leo,<space>molestie<space>ac,<space>sollicitudin<space>a,<space>suscipit<space>at,<space>ante.<space>Praesent<space>nec<space>purus.<space>Proin<space>cursus.<space>Praesent<space>ipsum<space>pede,<space>posuere<space>id,<space>congue<space>a,<space>hendrerit<space>id,<space>ligula.<space>Phasellus<space>tempus<space>pede<space>ut<space>neque<space>sagittis<space>dignissim.<space>Integer<space>in<space>odio<space>sed<space>est<space>dignissim<space>blandit.<space>Sed<space>sodales<space>viverra<space>nunc.<space>Pellentesque<space>feugiat.<space>Nulla<space>id<space>lorem<space>sit<space>amet<space>purus<space>egestas<space>rhoncus.<space>Vestibulum<space>nonummy.<space>Pellentesque<space>quis<space>lorem<space>et<space>erat<space>blandit<space>aliquam.<space>Ut<space>ut<space>ante<space>eu<space>sapien<space>viverra<space>lacinia.<space>Curabitur<space>sodales<space>dui<space>vel<space>turpis.<space>Fusce<space>felis<space>odio,<space>vestibulum<space>lacinia,<space>laoreet<space>eget,<space>tristique<space>eget,<space>tortor.<space>Sed<space>mauris.
abbreviate bbr ==============================================================================
"abbreviate br ------------------------------------------------------------------------------

"
" Functions
"
function! StripTrailingWhitespace()
    let _s=@/ " save last search
    let l = line(".") " save cursor position
    let c = col(".")
    exec ':%s/\s\+$//gc'
    let @/=_s " restore previous search
    call cursor(l, c) : restore cursor position
endfunction

"
" Mappings
"
set backspace=indent,eol,start " more useful backspace capability
let mapleader = "_" " lead with _
nmap <leader>l :set list!<CR> " show/hide hidden characters
nmap <leader>s : call StripTrailingWhitespace()<CR>

"
" Filetypes
"
au BufNewFile,BufRead *.as set ft=actionscript " remove Atlas association
