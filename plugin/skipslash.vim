let s:save_cpo = &cpo
set cpo&vim

if exists('g:skipslash')
  finish
endif
let g:skipslash = 1

augroup gotoslash
  autocmd!
  if !has('vim9script')
    autocmd CmdlineChanged : silent! call skipslash9#SetupOnSafeState()
    autocmd CmdlineLeave : silent! call skipslash9#Unmap()
  else
    autocmd CmdlineChanged : silent! call skipslash#setupOnSafeState()
    autocmd CmdlineLeave : silent! call skipslash#unmap()
  endif
augroup END

let &cpo = s:save_cpo
