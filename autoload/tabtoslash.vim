let s:dlm = ''

function! s:cl() abort
	return substitute(getcmdline(), s:escPat, '__', 'g')
endfunction

function! s:forward() abort
	return repeat("\<Right>", strchars(matchstr(s:cl(), s:forwardPat, getcmdpos() - 1)))
endfunction

function! s:back() abort
	return repeat("\<Left>", strchars(matchstr(strpart(s:cl(), 0, getcmdpos() - 1), s:backPat)))
endfunction

function! s:skip() abort
	let c = s:cl()
	let p = getcmdpos()
	if matchstr(c, '.', p - 1) == s:dlm && matchstr(c, '.', p - 2) != '\\'
		return "\<Right>"
	else
		return s:dlm
	endif
endfunction

function! s:setup(dlm) abort
	execute 'silent! cunmap <script> ' . s:dlm
	let s:dlm = a:dlm
	let l:d = escape(a:dlm, '^$&.*/\~[]')
	let s:escPat = '\\[\\' . l:d . ']'
	" Some symbols need to be enclosed in [].
	let s:forwardPat = '[^' . l:d . ']*[' . l:d . ']'
	let s:backPat = exists('g:tabtoslash_back_to_head') ? '[^D]*[D][^D]*$' : '[D][^D]*$'
	let s:backPat = substitute(s:backPat , 'D', l:d, 'g')
	cnoremap <script> <expr> <Tab> <SID>forward()
	cnoremap <script> <expr> <S-Tab> <SID>back()
	execute 'cnoremap <script> <expr> ' . s:dlm . ' <SID>skip()'
endfunction

function! tabtoslash#unmap() abort
	silent! cunmap <script> <Tab>
	silent! cunmap <script> <S-Tab>
	execute 'silent! cunmap <script> ' . s:dlm
	let s:dlm = ''
endfunction

function! tabtoslash#setup() abort
	let l:m = matchlist(getcmdline(), '^\S*s\(ubstitute\)\?\([!#-/:-@^_`~{}\[\]]\).*\1')
	if len(l:m)
		if s:dlm != l:m[2]
			call s:setup(l:m[2])
		endif
	elseif s:dlm != ''
		call tabtoslash#unmap()
	endif
endfunction

