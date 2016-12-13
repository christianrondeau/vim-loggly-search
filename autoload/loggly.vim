" Settings {{{
" '' = horizontal, 'v' = vertical
let g:loggly_splittype = get(g:, 'loggly_splittype', "")
let g:loggly_bufname = get(g:, 'loggly_bufname', ".loggly-search-output.json")
let g:loggly_default_from = get(g:, 'loggly_default_from', "-1h")
let g:loggly_default_until = get(g:, 'loggly_default_until', "now")
let g:loggly_default_size = get(g:, 'loggly_default_size', "50")
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
		setlocal buftype=nofile bufhidden=wipe noswapfile
	endif
	setlocal filetype=text
endfunction
" }}}

" Loggly encode {{{
function! loggly#queryencode(query)
	let l:query = substitute(a:query, "[+\–&|!(){}[\\]^\"~*?:\\\\]", " ", "g")
	return l:query
endfunction
" }}}

" Get rsid {{{
function! loggly#getsearchid()
	let l:pattern   = '\v"id": "(.*)"'
	let l:line      = search(l:pattern)
	let l:line_text = getline(l:line)
	let l:matched   = matchlist(l:line_text, l:pattern)
	echom join(l:matched)
	if len(l:matched) >= 2
		return l:matched[1]
	else
		return ""
	endif
endfunction
" }}}

function! loggly#searchtext(value)
	return loggly#search("\"" . loggly#queryencode(a:value) . "\"")
endfunction

function! loggly#validateinput(value) abort
	if(strlen(a:value) <= 0)
		throw "A value is required, cancelling loggly search"
	endif
	return a:value
endfunction

function! loggly#paramescape(key, value)
	if stridx(&shell, 'cmd') != -1
		return '"' . a:key . '=' . substitute(a:value, '"', '"""', 'g') . '"'
	else
		return shellescape(a:key . "=" . a:value)
	endif
endfunction

function! loggly#search(value) abort
	" Ensure settings were configured
	call loggly#sanitycheck()

	" Ask for search terms
	call inputsave()
	let l:value = input('Loggly - Search: ', a:value)
	let g:loggly_lastsearch = l:value
	let g:loggly_default_from = loggly#validateinput(input('Loggly - From: ', g:loggly_default_from))
	let g:loggly_default_until = loggly#validateinput(input('Loggly - Until: ', g:loggly_default_until))
	let g:loggly_default_size = loggly#validateinput(input('Loggly - Limit results to: ', g:loggly_default_size))
	call inputrestore()

	" Open results buffer
	call loggly#gotobuf()

	" Wait message
	call setline(1, "Searching for: " . l:value)
	redraw!

	" Search
	let l:cmd = "silent! read! curl" .
		\ " -sS -G " . g:loggly_curl_auth .
		\ " " . shellescape("https://" . g:loggly_account . ".loggly.com/apiv2/search", 1) .
		\ " --data-urlencode " . loggly#paramescape("q", l:value) .
		\ " --data-urlencode " . loggly#paramescape("from", g:loggly_default_from) .
		\ " --data-urlencode " . loggly#paramescape("until", g:loggly_default_until) .
		\ " --data-urlencode " . loggly#paramescape("size", g:loggly_default_size)
	execute l:cmd

	" Get search id
	let l:searchid = loggly#getsearchid()
	if strlen(l:searchid) < 6
		throw "Could not get the rsid"
	endif

	" Waiting for events
	normal! 2GdG
	call setline(2, "Waiting for events \"" . l:searchid . "\"...")
	redraw!
	normal! ggdG
	
	" Get events
	let l:cmd = "silent! read! curl" .
		\ " -sS -G " . g:loggly_curl_auth .
		\ " " . shellescape("https://" . g:loggly_account . ".loggly.com/apiv2/events", 1) .
		\ " --data-urlencode " . loggly#paramescape("rsid", l:searchid)
	execute l:cmd
	normal! ggdd

	" Prepare results
	setlocal filetype=json
	if exists("g:loggly_filter")
		execute g:loggly_filter
	endif
endfunction
