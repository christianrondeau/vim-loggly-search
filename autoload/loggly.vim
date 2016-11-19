" n = horizontal, v = vertical
let g:loggly_splittype = get(g:, 'loggly_splittype', "n")


function! loggly#search(value)
	exe "norm! \<c-w>" . g:loggly_splittype
	execute "read !curl -s -u username:password \"http://account.loggly.com/apiv2/search?q=*&from=-2h&until=now&size=10\""
endfunction
