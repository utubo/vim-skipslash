⚠This is the beta version.

# vim-tabtoslash

You can `<TAB>` to move to the next block when the command line is `:s/{pattern}/{string}/`,
and automatically skips '/'.

## Install

```vim
call dein#add('utubo/vim-tabtoslash')
```

(Optional)
```vim
nnoremap gs :<C-u>s///cg<Left><Left><Left><Left>
nnoremap gS :<C-u>%s/<C-r>=escape(expand('<cword>'), '^$.*?/\[]')<CR>//cg<Left><Left><Left>
vnoremap gs :s///cg<Left><Left><Left><Left>
```

## Examples

`|` is the cursor.

### Move to the next block. (Key: `<TAB>`)
`:s/p|at/str/` -> `:s/pat/|str/`

### Move to the previouse block. (Key: `<S-TAB>`)

`:s/pat/s|tr/` -> `:s/pat|/str/`

(Option)
```vim
g:tabtoslash_back_to_head = 1
```

`:s/pat/s|tr/` -> `:s/|pat/str/`

### Skip `/`. (Key: `/`)

`:s/pat|/str/` -> `:s/pat/|str/`

( When "/" is escaped with "\\" ...)

`:s/pat\|/str/` -> `:s/pat\/|/str/`

