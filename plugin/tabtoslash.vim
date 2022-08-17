let s:save_cpo = &cpo
set cpo&vim

if exists('g:tabtoslash')
  finish
endif
let g:tabtoslash = 1

augroup gotoslash
  autocmd!
  if has('vim9script')
    autocmd CmdlineChanged : silent! call tabtoslash9#Setup()
    autocmd CmdlineLeave : silent! call tabtoslash9#Unmap()
  else
    autocmd CmdlineChanged : silent! call tabtoslash#setup()
    autocmd CmdlineLeave : silent! call tabtoslash#unmap()
  endif
augroup END

let &cpo = s:save_cpo
