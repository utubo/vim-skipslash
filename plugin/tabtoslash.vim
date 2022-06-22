if exists('g:tabtoslash')
  finish
endif
let g:tabtoslash = 1

augroup gotoslash
  autocmd!
  autocmd CmdlineChanged : call tabtoslash#setup()
  autocmd CmdlineLeave : call tabtoslash#unmap()
augroup END

