nnoremap <Plug>LogglySearch :call loggly#search(get(g:, 'loggly_lastsearch', ""))<cr>
vnoremap <Plug>LogglySearch y:call loggly#searchtext(@")<cr>

if(!hasmapto('<Plug>LogglySearch'))
	map <silent> <leader>loggly <Plug>LogglySearch
endif

command! -nargs=1 LogglySearch call loggly#searchtext(<f-args>)
