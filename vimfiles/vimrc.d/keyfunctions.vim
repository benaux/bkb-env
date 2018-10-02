
function! Vif()
    silent !clear
"    execute 'silent make! -f vi.mk vif 2>&1 > /dev/null \&' | redraw!
"   silent execute  'make -s -f vi.mk vif > /dev/null 2>&1 &' | execute ':redraw!'
   silent execute  '!(make -s -f dev.mk vif &) > /dev/null' | execute ':redraw!'
endfunction

function! Vit()
    silent !clear
    silent execute  "make -f dev.mk vit  > /dev/null &" | redraw!
endfunction

nnoremap f :w<cr>:call Vif()<cr>
nnoremap t :w<cr>:call Vit()<cr>

"refresh syntax higlight (specially helpfulll for large multi-syntax files
"like org-mode
nnoremap s :w<cr>:syn sync fromstart<cr>
