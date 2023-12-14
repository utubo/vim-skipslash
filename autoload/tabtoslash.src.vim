let s:save_cpo = &cpo
set cpo&vim

let s:dlm = ''
let s:clBackup = ''
let s:mapBackup = {}

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

function! s:setupImpl(dlm) abort
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

function! s:autoComplete(cl, c, d) abort
  if get(g:, 'tabtoslash_autocomplete', 0) ==# 0 ||
       \ len(a:cl) !=# len(s:clBackup) + 1 ||
       \ getcmdpos() !=# len(a:cl) + 1
    return
  elseif a:c ==# 's'
    call feedkeys($"{a:d}{a:d}g\<Left>\<Left>\<Left>", 'nit')
  else
    call feedkeys($"{a:d}\<Left>", 'nit')
  endif
endfunction

function! s:setup() abort
  const l:cl = getcmdline()
  const l:m = matchlist(l:cl, '^\S*\([sgv]\|substitute\|g!\)\([/#-:-@^_`~]\)\(.*\2\)\?')
  if len(l:m)
  let g:a = l:m
    if m[3] ==# ''
      call s:autoComplete(l:cl, m[1], m[2])
    elseif s:dlm !=# l:m[2]
      call s:setupImpl(l:m[2])
    endif
  elseif s:dlm !=# ''
    call tabtoslash#unmap()
  endif
  let s:clBackup = cl
endfunction

function! tabtoslash#setupOnSafeState() abort
  autocmd SafeState * ++once call s:setup()
endfunction

let &cpo = s:save_cpo
