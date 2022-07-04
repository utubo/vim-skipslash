let s:b = ''
fu! s:Fb() abort
return substitute(getcmdline(), s:c, '  ', 'g')
endf
fu! s:Fc() abort
return repeat("\<Right>", strchars(matchstr(s:Fb(), s:d, getcmdpos() - 1)))
endf
fu! s:Fd() abort
return repeat("\<Left>", strchars(matchstr(strpart(s:Fb(), 0, getcmdpos() - 1), s:e)))
endf
fu! s:Fe() abort
return matchstr(s:Fb(), '.', getcmdpos() - 1) == s:b ? "\<Right>" : s:b
endf
fu! s:Ff(b) abort
exe 'silent! cunmap <script> ' . s:b
let s:b = a:b
let l:d = escape(a:b, '^$<ESCMARK:0>.*/\~[]')
let s:c = '\\[\\' . l:d . ']'
let s:d = '[^' . l:d . ']*[' . l:d . ']'
let s:e = '[' . l:d . '][^' . l:d . ']*$'
if exists('g:tabtoslash_back_to_head')
let s:e = '[^' . l:d . ']*' . s:e
endif
cno <script> <expr> <Tab> <SID>Fc()
cno <script> <expr> <S-Tab> <SID>Fd()
exe 'cnoremap <script> <expr> ' . s:b . ' <SID>skip()'
endf
fu! tabtoslash#unmap() abort
silent! cunmap <script> <Tab>
silent! cunmap <script> <S-Tab>
exe 'silent! cunmap <script> ' . s:b
let s:b = ''
endf
fu! tabtoslash#setup() abort
let l:m = matchlist(getcmdline(), '^\S*\(s\|substitute\)\([!#-/:-@^_`~{}\[\]]\).*\2')
if len(l:m)
if s:b != l:m[2]
call s:Ff(l:m[2])
endif
elseif s:b != ''
call tabtoslash#unmap()
endif
endf
