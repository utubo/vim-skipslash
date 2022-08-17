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
  execute 'silent! cunmap <script>' s:dlm
  let s:dlm = a:dlm
  let l:d = escape(a:dlm, '^$&.*/\~[]')
  let s:escPat = $'\\[\\{l:d}]'
  " Some symbols need to be enclosed in [].
  let s:forwardPat = $'[^{l:d}]*[{l:d}]'
  let s:backPat = $'[{l:d}][^{l:d}]*$'
  if exists('g:tabtoslash_back_to_head')
    let s:backPat = $'[^{l:d}]*{s:backPat}'
  endif
  cnoremap <script> <expr> <Tab> <SID>forward()
  cnoremap <script> <expr> <S-Tab> <SID>back()
  execute 'cnoremap <script> <expr>' s:dlm '<SID>skip()'
endfunction

function! tabtoslash#unmap() abort
  silent! cunmap <script> <Tab>
  silent! cunmap <script> <S-Tab>
  execute 'silent! cunmap <script>' s:dlm
  let s:dlm = ''
endfunction

function! tabtoslash#setup() abort
  let l:m = matchlist(getcmdline(), '^\S*\(s\|substitute\)\([!#-/:-@^_`~{}\[\]]\).*\2')
  if len(l:m)
    if s:dlm != l:m[2]
      call s:setup(l:m[2])
    endif
  elseif s:dlm != ''
    call tabtoslash#unmap()
  endif
endfunction

let &cpo = s:save_cpo
