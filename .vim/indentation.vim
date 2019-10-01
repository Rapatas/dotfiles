
" Indent means 4
let &shiftwidth = g:indent_size

" What to do when you press TAB (Must be the same as tabstop)
let &softtabstop = g:indent_size

" How to display a tab Character
let &tabstop = g:indent_size

" Round indent to multiple of 'shiftwidth'
set shiftround

" Stop inserting new lines at long lines
set formatoptions-=t

" Cinoptions {{{

" Normal indentation
set cinoptions=>1s

" Place Jump Labels at column 0
set cinoptions+=L-1

" Place case one level after switch
set cinoptions+=:1s

" Place blocks in switch correctly
set cinoptions+=l1

" Place c++ scope to col 0
set cinoptions+=g0

" Place return type at col 0, when the function is global
set cinoptions+=t0

" Place base class
set cinoptions+=i1s

" Place Continuation line
set cinoptions+=+1s

" Place multi-line comments
set cinoptions+=c1s,C1s

" indent unclosed parens
set cinoptions+=(1s,u1s,U1s

" FIX closing paren
set cinoptions+=m1

" FIX Lambdas
set cinoptions+=j1

" Dont indent namespace
" indent negative
set cinoptions+=N-s

" }}}

" HTML {{{

" HTML better ENTER
function! Expander()
	let line   = getline(".")
	let col    = col(".")
	let first  = line[col-2]
	let second = line[col-1]
	let third  = line[col]

	if first ==# ">"
		if second ==# "<" && third ==# "/"
			return "\<CR>\<C-o>==\<C-o>O"
		else
			return "\<CR>"
		endif
	else
		return "\<CR>"
	endif
endfunction

inoremap <expr> <CR> Expander()

" }}}

" C++ {{{

" If previous non-empty line is template, return the indentation of that line
function! Dont_indent_templates()

	let curr_line_num = line('.')
	let prev_line_num = prevnonblank(curr_line_num - 1)
	let prev_line = getline(prev_line_num)

	if prev_line =~# '^\s*template.*'
		let ret_val = indent(prev_line_num)
	else
		let ret_val = cindent(curr_line_num)
	endif

	return ret_val
endfunction

if has("autocmd")
	autocmd BufEnter *.{cc,cxx,cpp,h,hh,hpp,hxx} setlocal indentexpr=Dont_indent_templates()
endif

" }}}

" Markdown {{{

" Markdown spaces
autocmd BufRead,BufNewFile *.md setlocal softtabstop=4 shiftwidth=4 tabstop=4 expandtab

" }}}
