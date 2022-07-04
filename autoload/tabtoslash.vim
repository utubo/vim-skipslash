let s:a = ''
fu! s:Fa() abort
return substitute(getcmdline(), s:a, '  ', 'g')
endf
fu! s:Fa() abort
return repeat("\<Right>", strchars(matchstr(s:Fa(), s:a, getcmdpos() - 1)))
endf
fu! s:Fa() abort
return repeat("\<Left>", strchars(matchstr(strpart(s:Fa(), 0, getcmdpos() - 1), s:a)))
endf
fu! s:Fa() abort
return matchstr(s:Fa(), '.', getcmdpos() - 1) == s:a ? "\<Right>" : s:a
endf
fu! s:Fa(a) abort
exe 'silent! cunmap <script> ' . s:a
let s:a = a:a
let l:d = escape(a:a, '^$<ESCMARK:0>.*/\~[]')
let s:a = '\\[\\' . l:d . ']'
let s:a = '[^' . l:d . ']*[' . l:d . ']'
let s:a = '[' . l:d . '][^' . l:d . ']*$'
if exists('g:tabtoslash_back_to_head')
let s:a = '[^' . l:d . ']*' . s:a
endif
cno <script> <expr> <Tab> <SID>Fa()
cno <script> <expr> <S-Tab> <SID>Fa()
exe 'cnoremap <script> <expr> ' . s:a . ' <SID>skip()'
endf
fu! tabtoslash#unmap() abort
silent! cunmap <script> <Tab>
silent! cunmap <script> <S-Tab>
exe 'silent! cunmap <script> ' . s:a
let s:a = ''
endf
fu! tabtoslash#setup() abort
let l:m = matchlist(getcmdline(), '^\S*\(s\|substitute\)\([!#-/:-@^_`~{}\[\]]\).*\2')
if len(l:m)
if s:a != l:m[2]
call s:Fa(l:m[2])
endif
elseif s:a != ''
call tabtoslash#unmap()
endif
endf
