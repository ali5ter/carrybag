fun! s:DetectNode()
    if getline(1) == '#!/usr/local/bin/node'
    set ft=javascript
    endif
endfun

autocmd BufNewFile,BufRead * call s:DetectNode()
