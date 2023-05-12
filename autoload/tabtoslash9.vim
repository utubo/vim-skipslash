vim9script

var dlm = ''
var escPat = ''
var forwardPat = ''
var backPat = ''

# get cmdline widhout escaped delmiters.
def Cl(): string
  return substitute(getcmdline(), escPat, '  ', 'g')
enddef

def Forward(): string
  return repeat("\<Right>", strchars(matchstr(Cl(), forwardPat, getcmdpos() - 1)))
enddef

def Back(): string
  return repeat("\<Left>", strchars(matchstr(strpart(Cl(), 0, getcmdpos() - 1), backPat)))
enddef

def Skip(): string
  return matchstr(Cl(), '.', getcmdpos() - 1) == dlm ? "\<Right>" : dlm
enddef

def SetupImpl(newDlm: string)
  execute 'silent! cunmap <script>' dlm
  dlm = newDlm
  var d = escape(newDlm, '^$&.*/\~[]')
  escPat = $'\\[\\{d}]'
  # Some symbols need to be enclosed in [].
  forwardPat = $'[^{d}]*[{d}]'
  backPat = $'[{d}][^{d}]*$'
  if exists('g:tabtoslash_back_to_head')
    backPat = $'[^{d}]*{backPat}'
  endif
  cnoremap <script> <expr> <Tab> <SID>Forward()
  cnoremap <script> <expr> <S-Tab> <SID>Back()
  execute 'cnoremap <script> <expr>' dlm '<SID>Skip()'
enddef

export def Unmap()
  silent! cunmap <script> <Tab>
  silent! cunmap <script> <S-Tab>
  execute 'silent! cunmap <script>' dlm
  dlm = ''
enddef

export def Setup()
  var m = matchlist(getcmdline(), '^\S*\([sgv]\|substitute\|g!\)\([!#-/:-@^_`~{}\[\]]\).*\2')
  if len(m) !=# 0
    if dlm != m[2]
      SetupImpl(m[2])
    endif
  elseif dlm !=# ''
    Unmap()
  endif
enddef

