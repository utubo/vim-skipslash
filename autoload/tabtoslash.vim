let s:a = ''
fu! s:Fa() abort
return substitute(getcmdline(), s:b, '  ', 'g')
endf
fu! s:Fb() abort
return repeat("\<Right>", strchars(matchstr(s:Fa(), s:c, getcmdpos() - 1)))
endf
fu! s:Fc() abort
return repeat("\<Left>", strchars(matchstr(strpart(s:Fa(), 0, getcmdpos() - 1), s:d)))
endf
fu! s:Fd() abort
return matchstr(s:Fa(), '.', getcmdpos() - 1) == s:a ? "\<Right>" : s:a
endf
fu! s:Fe(a) abort
exe 'silent! cunmap <script> ' . s:a
let s:a = a:a
let l:d = escape(a:a, '^$<ESCMARK:0>.*/\~[]')
let s:b = '\\[\\' . l:d . ']'
let s:c = '[^' . l:d . ']*[' . l:d . ']'
let s:d = '[' . l:d . '][^' . l:d . ']*$'
if exists('g:tabtoslash_back_to_head')
let s:d = '[^' . l:d . ']*' . s:d
endif
cno <script> <expr> <Tab> <SID>Fb()
cno <script> <expr> <S-Tab> <SID>Fc()
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
call s:Fe(l:m[2])
endif
elseif s:a != ''
call tabtoslash#unmap()
endif
endf
