let s:a=&cpo
set cpo&vim
let s:b=''
let s:c=''
let s:d={}
fu! s:A() abort
retu substitute(getcmdline(),s:e,'  ','g')
endf
fu! s:B() abort
retu repeat("\<Right>",strchars(matchstr(s:A(),s:f,getcmdpos()-1)))
endf
fu! s:C() abort
retu repeat("\<Left>",strchars(matchstr(strpart(s:A(),0,getcmdpos()-1),s:g)))
endf
fu! s:D() abort
retu matchstr(s:A(),'.',getcmdpos()-1)==s:b ? "\<Right>" : s:b
endf
fu! s:setupImpl(b) abort
call tabtoslash#unmap()
let s:b=a:b
let l:d=escape(a:b,'^$&.*/\~[]')
let s:e=$'\\[\\{l:d}]'
let s:f=$'[^{l:d}]*[{l:d}]'
let s:g=$'[{l:d}][^{l:d}]*$'
if exists('g:tabtoslash_back_to_head')
let s:g=$'[^{l:d}]*{s:g}'
endif
for l:c in ['<Tab>','<S-Tab>',s:b]
let s:d[l:c]=maparg(l:c,'c',0,1)
endfo
cno <script> <expr> <Tab> <SID>B()
cno <script> <expr> <S-Tab> <SID>C()
exe 'cnoremap <script> <expr>' s:b '<SID>D()'
endf
fu! tabtoslash#unmap() abort
for l:a in keys(s:d)
let l:b=s:d[l:a]
if empty(l:b)
exe 'silent! cunmap' l:a
else
call mapset('c',0,l:b)
endif
endfo
let s:d={ }
let s:b=''
endf
fu! s:F(b,c,d) abort
if get(g:,'tabtoslash_autocomplete',0)==# 0 || len(a:b) !=# len(s:c)+1 || getcmdpos() !=# len(a:b)+1
retu
elseif a:c==# 's'
call feedkeys($"{a:d}{a:d}g\<Left>\<Left>\<Left>",'nit')
else
call feedkeys($"{a:d}\<Left>",'nit')
endif
endf
fu! s:G() abort
cons l:b=getcmdline()
cons l:m=matchlist(l:b,'^\S*\([sgv]\|substitute\|g!\)\([/#-:-@^_`~]\)\(.*\2\)\?')
if len(l:m)
let g:a=l:m
if m[3]==# ''
call s:F(l:b,m[1],m[2])
elseif s:b !=# l:m[2]
call s:setupImpl(l:m[2])
endif
elseif s:b !=# ''
call tabtoslash#unmap()
endif
let s:c=b
endf
fu! tabtoslash#setupOnSafeState() abort
au SafeState * ++once call s:G()
endf
let &cpo=s:a
