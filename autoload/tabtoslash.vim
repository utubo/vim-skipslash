let s:a = ''
fu! s:A() abort
return substitute(getcmdline(), s:b, '  ', 'g')
endf
fu! s:B() abort
return repeat("\<Right>", strchars(matchstr(s:A(), s:c, getcmdpos() - 1)))
endf
fu! s:C() abort
return repeat("\<Left>", strchars(matchstr(strpart(s:A(), 0, getcmdpos() - 1), s:d)))
endf
fu! s:D() abort
return matchstr(s:A(), '.', getcmdpos() - 1) == s:a ? "\<Right>" : s:a
endf
fu! s:E(b) abort
exe 'silent! cunmap <script> ' . s:a
let s:a = a:b
let l:d = escape(a:b, '^$&.*/\~[]')
let s:b = '\\[\\' . l:d . ']'
let s:c = '[^' . l:d . ']*[' . l:d . ']'
let s:d = '[' . l:d . '][^' . l:d . ']*$'
if exists('g:tabtoslash_back_to_head')
let s:d = '[^' . l:d . ']*' . s:d
endif
cno <script> <expr> <Tab> <SID>B()
cno <script> <expr> <S-Tab> <SID>C()
exe 'cnoremap <script> <expr> ' . s:a . ' <SID>D()'
endf
fu! tabtoslash#unmap() abort
sil! cu <script> <Tab>
sil! cu <script> <S-Tab>
exe 'silent! cunmap <script> ' . s:a
let s:a = ''
endf
fu! tabtoslash#setup() abort
let l:m = matchlist(getcmdline(), '^\S*\(s\|substitute\)\([!#-/:-@^_`~{}\[\]]\).*\2')
if len(l:m)
if s:a != l:m[2]
call s:E(l:m[2])
endif
elseif s:a != ''
call tabtoslash#unmap()
endif
endf
