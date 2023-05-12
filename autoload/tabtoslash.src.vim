let s:save_cpo = &cpo
set cpo&vim

let s:dlm = ''

" get cmdline widhout escaped delmiters.
function! s:cl() abort
  return substitute(getcmdline(), s:escPat, '  ', 'g')
endfunction

function! s:forward() abort
  return repeat("\<Right>", strchars(matchstr(s:cl(), s:forwardPat, getcmdpos() - 1)))
endfunction

function! s:back() abort
  return repeat("\<Left>", strchars(matchstr(strpart(s:cl(), 0, getcmdpos() - 1), s:backPat)))
endfunction

function! s:skip() abort
  return matchstr(s:cl(), '.', getcmdpos() - 1) == s:dlm ? "\<Right>" : s:dlm
endfunction

function! s:setup(dlm) abort
  call tabtoslash#unmap()
  let s:dlm = a:dlm
  let l:d = escape(a:dlm, '^$&.*/\~[]')
  let s:escPat = $'\\[\\{l:d}]'
  " Some symbols need to be enclosed in [].
  let s:forwardPat = $'[^{l:d}]*[{l:d}]'
  let s:backPat = $'[{l:d}][^{l:d}]*$'
  if exists('g:tabtoslash_back_to_head')
    let s:backPat = $'[^{l:d}]*{s:backPat}'
  endif
  for l:key in ['<Tab>', '<S-Tab>', s:dlm]
    let s:mapBackup[l:key] = maparg(l:key, 'c', 0, 1)
  endfor
  cnoremap <script> <expr> <Tab> <SID>forward()
  cnoremap <script> <expr> <S-Tab> <SID>back()
  execute 'cnoremap <script> <expr>' s:dlm '<SID>skip()'
endfunction

function! tabtoslash#unmap() abort
  for l:key in keys(s:mapBackup)
    let l:val = s:mapBackup[l:key]
    if empty(l:val)
      execute 'silent! cunmap' l:key
    else
      call mapset('c', 0, l:val)
    endif
  endfor
  let s:mapBackup = { }
  let s:dlm = ''
endfunction

function! tabtoslash#setup() abort
  let l:m = matchlist(getcmdline(), '^\S*\([sgv]\|substitute\|g!\)\([!#-/:-@^_`~{}\[\]]\).*\2')
  if len(l:m)
    if s:dlm != l:m[2]
      call s:setup(l:m[2])
    endif
  elseif s:dlm != ''
    call tabtoslash#unmap()
  endif
endfunction

let &cpo = s:save_cpo
