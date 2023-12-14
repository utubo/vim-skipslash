⚠This is the beta version.  
⚠(2023/12/14) Rename plugin name from `vim-tabtoslash` to `vim-skipslash`

# vim-skipslash

You can `<TAB>` to move to the next block when the command line is `:s/{pattern}/{string}/` or `:g/{pattern}/`,
and automatically skips '/'.

## Install

```vim
call dein#add('utubo/vim-skipslash')
```

(Optional)
```vim
nnoremap gs :<C-u>s///cg<Left><Left><Left><Left>
nnoremap gS :<C-u>%s/<C-r>=escape(expand('<cword>'), '^$.*?/\[]')<CR>//cg<Left><Left><Left>
vnoremap gs :s///cg<Left><Left><Left><Left>
let g:skipslash_autocomplete = 1
```

## Usage

`|` is the cursor.

### Move to the next block. (Key: `<TAB>`)
`:s/p|at/str/` -> `:s/pat/|str/`

### Move to the previouse block. (Key: `<S-TAB>`)

`:s/pat/s|tr/` -> `:s/pat|/str/`

(Option)
```vim
let g:skipslash_back_to_head = 1
```

`:s/pat/s|tr/` -> `:s/|pat/str/`

### Skip `/`. (Key: `/`)

`:s/pat|/str/` -> `:s/pat/|str/`

( When "/" is escaped with "\\" ...)

`:s/pat\|/str/` -> `:s/pat\/|/str/`

## Auto complete the slashes
```vim
let g:skipslash_autocomplete = 1
```

- `:s/` -> `:s///g`
- `:g/` -> `:g//`
- `:v/` -> `:v//`
- `:g!/` -> `:g!//`

## Supported delimiters
- `/`, `#`, `-`, `:`, `-`, `@`, `^`, `_`, `~`

This plugin works on e.g.
```
:s#foo#bar#
```

