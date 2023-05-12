let s:a=&cpo
set cpo&vim
let s:b=''
fu! s:A() abort
retu substitute(getcmdline(),s:c,'  ','g')
endf
fu! s:B() abort
retu repeat("\<Right>",strchars(matchstr(s:A(),s:d,getcmdpos()-1)))
endf
fu! s:C() abort
retu repeat("\<Left>",strchars(matchstr(strpart(s:A(),0,getcmdpos()-1),s:e)))
endf
fu! s:D() abort
retu matchstr(s:A(),'.',getcmdpos()-1)==s:b ? "\<Right>" : s:b
endf
fu! s:E(b) abort
call tabtoslash#unmap()
let s:b=a:b
let l:d=escape(a:b,'^$&.*/\~[]')
let s:c=$'\\[\\{l:d}]'
let s:d=$'[^{l:d}]*[{l:d}]'
let s:e=$'[{l:d}][^{l:d}]*$'
if exists('g:tabtoslash_back_to_head')
let s:e=$'[^{l:d}]*{s:e}'
endif
for l:c in ['<Tab>','<S-Tab>',s:b]
let s:f[l:c]=maparg(l:c,'c',0,1)
endfo
cno <script> <expr> <Tab> <SID>B()
cno <script> <expr> <S-Tab> <SID>C()
exe 'cnoremap <script> <expr>' s:b '<SID>D()'
endf
fu! tabtoslash#unmap() abort
for l:a in keys(s:f)
let l:b=s:f[l:a]
if empty(l:b)
exe 'silent! cunmap' l:a
else
call mapset('c',0,l:b)
endif
endfo
let s:f={ }
let s:b=''
endf
fu! tabtoslash#setup() abort
let l:m=matchlist(getcmdline(),'^\S*\([sgv]\|substitute\|g!\)\([!#-/:-@^_`~{}\[\]]\).*\2')
if len(l:m)
if s:b !=l:m[2]
call s:E(l:m[2])
endif
elseif s:b !=''
call tabtoslash#unmap()
endif
endf
let &cpo=s:a
