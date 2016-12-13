nnoremap <silent> <leader>loggly :call loggly#search(get(g:, 'loggly_lastsearch', ""))<cr>
vnoremap <silent> <leader>loggly y:call loggly#searchtext(@")<cr>
command -nargs=1 LogglySearch call loggly#searchtext(<f-args>)
