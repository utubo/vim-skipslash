vim9script

var dlm = ''
var escPat = ''
var forwardPat = ''
var backPat = ''
var mapBackup = { }
var clBackup = ''

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
  Unmap()
  dlm = newDlm
  var d = escape(dlm, '^$&.*/\~[]')
  escPat = $'\\[\\{d}]'
  # Some symbols need to be enclosed in [].
  forwardPat = $'[^{d}]*[{d}]'
  backPat = $'[{d}][^{d}]*$'
  if exists('g:tabtoslash_back_to_head')
    backPat = $'[^{d}]*{backPat}'
  endif
  for key in ['<Tab>', '<S-Tab>', dlm]
    mapBackup[key] = maparg(key, 'c', 0, 1)
  endfor
  cnoremap <script> <expr> <Tab> <SID>Forward()
  cnoremap <script> <expr> <S-Tab> <SID>Back()
  execute 'cnoremap <script> <expr>' dlm '<SID>Skip()'
enddef

export def Unmap()
  for key in keys(mapBackup)
    const val = mapBackup[key]
    if empty(val)
      execute 'silent! cunmap' key
    else
      mapset(val)
    endif
  endfor
  mapBackup = { }
  dlm = ''
enddef

def AutoComplete(cl: string, c: string, d: string)
  if get(g:, 'tabtoslash_autocomplete', 0) ==# 0 ||
      len(cl) !=# len(clBackup) + 1 ||
      getcmdpos() !=# len(cl) + 1
    return
  elseif c ==# 's'
    feedkeys($"{d}{d}g\<Left>\<Left>\<Left>", 'nit')
  else
    feedkeys($"{d}\<Left>", 'nit')
  endif
enddef

def Setup()
  const cl = getcmdline()
  const m = matchlist(cl, '^\S*\([sgv]\|substitute\|g!\)\([/#-:-@^_`~]\)\(.*\2\)\?')
  if len(m) !=# 0
    if m[3] ==# ''
      AutoComplete(cl, m[1], m[2])
    elseif dlm !=# m[2]
      SetupImpl(m[2])
    endif
  elseif dlm !=# ''
    silent! Unmap()
  endif
  clBackup = cl
enddef

export def SetupOnSafeState()
  autocmd SafeState * ++once Setup()
enddef

