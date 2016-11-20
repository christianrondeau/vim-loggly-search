" Settings {{{
" '' = horizontal, 'v' = vertical
let g:loggly_splittype = get(g:, 'loggly_splittype', "")
let g:loggly_bufname = get(g:, 'loggly_bufname', ".loggly-search-output.json")
" }}}

" Sanity check {{{
function! loggly#sanitycheck()
	if(!exists("g:loggly_account"))
		throw "Loggly: g:loggly_account must be set"
	endif

	if(!exists("g:loggly_curl_auth"))
		throw "Loggly: g:loggly_curl_auth must be set"
	endif
endfunction
" }}}

" Search Buffer {{{
function! loggly#gotobuf()
	let winnr = bufwinnr('^' . g:loggly_bufname . '$')
	if ( winnr >= 0 )
		execute winnr . 'wincmd w'
		normal! ggdG
	else
		execute g:loggly_splittype . 'new ' . g:loggly_bufname
		setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
	endif
	setlocal filetype=
endfunction
" }}}

" Get rsid {{{
function! loggly#getsearchid()
	let l:pattern   = '\v"id": "(.*)"'
	let l:line      = search(l:pattern)
	let l:line_text = getline(l:line)
	let l:matched   = matchlist(l:line_text, l:pattern)
	return l:matched[1]
endfunction
" }}}

function! loggly#search(value)
	call loggly#sanitycheck()
	call loggly#gotobuf()

	call setline(1, "Searching for \"" . a:value . "\"...")
	redraw!

	execute "silent! read! curl -sS " . g:loggly_curl_auth . " \"https://" . g:loggly_account . ".loggly.com/apiv2/search?q=" . a:value . "&from=-2h&until=now&size=10\""

	let l:searchid = loggly#getsearchid()

	if strlen(l:searchid) < 6
		throw "Could not get a search id"
	endif

	normal! 2GdG
	call setline(2, "Waiting for rsid \"" . l:searchid . "\"...")
	redraw!
	normal! ggdG
	
	execute "silent! read! curl -sS " . g:loggly_curl_auth . " \"https://" . g:loggly_account . ".loggly.com/apiv2/events?rsid=" . l:searchid . "\""
	normal! ggdd

	setlocal filetype=json
endfunction
