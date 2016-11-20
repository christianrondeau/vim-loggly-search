" Settings {{{
" '' = horizontal, 'v' = vertical
let g:loggly_splittype = get(g:, 'loggly_splittype', "")
let g:loggly_bufname = get(g:, 'loggly_bufname', ".loggly-search-output.json")
let g:loggly_default_from = get(g:, 'loggly_default_from', "-1h")
let g:loggly_default_until = get(g:, 'loggly_default_until', "now")
let g:loggly_default_size = get(g:, 'loggly_default_size', "10")
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

	" Ensure settings were configured
	call loggly#sanitycheck()

	" Ask for search terms
	call inputsave()
	let l:value = input('Loggly - Search: ', a:value)
	let g:loggly_default_from = input('Loggly - From: ', g:loggly_default_from)
	let g:loggly_default_until = input('Loggly - Until: ', g:loggly_default_until)
	let g:loggly_default_size = input('Loggly - Limit results to: ', g:loggly_default_size)
	call inputrestore()

	" Keep search for next time
	let g:loggly_lastsearch = l:value

	" Open results buffer
	call loggly#gotobuf()

	" Wait message
	call setline(1, "Searching for \"" . l:value . "\"...")
	redraw!

	" Search
	execute "silent! read! curl -sS " . g:loggly_curl_auth . " \"https://" . g:loggly_account . ".loggly.com/apiv2/search?q=" . l:value . "&from=" . g:loggly_default_from . "&until=" . g:loggly_default_until . "&size=" . g:loggly_default_size . "\""

	" Get search id
	let l:searchid = loggly#getsearchid()
	if strlen(l:searchid) < 6
		throw "Could not get a search id"
	endif

	" Waiting for events
	normal! 2GdG
	call setline(2, "Waiting for rsid \"" . l:searchid . "\"...")
	redraw!
	normal! ggdG
	
	" Get events
	execute "silent! read! curl -sS " . g:loggly_curl_auth . " \"https://" . g:loggly_account . ".loggly.com/apiv2/events?rsid=" . l:searchid . "\""
	normal! ggdd

	" Prepare results
	setlocal filetype=json
endfunction
