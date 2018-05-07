# Vim Loggly Search

Searches for the visually selected text in [Loggly](https://www.loggly.com).

# Installation

## Prerequisites

* A [Loggly](https://www.loggly.com) account
* Requires `curl` to be installed and in the `PATH`.

## Plugin

Use your preferred Vim plugin installation method. If you like [vim-plug](https://github.com/junegunn/vim-plug):

Add to your `.vimrc`:

    Plug 'christianrondeau/vim-loggly-search'

And install it:

    :PlugInstall

## Basic Configuration

You also need to assign these variables in your `.vimrc`:

    " Your <account>.loggly.com
    let g:loggly_account = "account_name"

    " Either:
    "  * --netrc-file path-to-netrc-file (see https://ec.haxx.se/usingcurl-netrc.html)
    "  * -u username:password
    "  * -H "Authorization: bearer YOUR-LOGGLY-TOKEN" (see https://mediaclip.loggly.com/account/users/api/tokens)
    let g:loggly_curl_auth = '-H "Authorization: bearer 00000000-0000-0000-0000-000000000000"'

## Windows

* Install [cURL](https://curl.haxx.se/) and make sur it's in your `PATH`
* Download https://curl.haxx.se/ca/cacert.pem as `curl-ca-bundle.crt`, and put it somewhere available in your `PATH`

# Usage

Type `<leader>loggly` to start a search and show results in a new split buffer. It also will automatically prepopulate the search when using the shortcut in visual mode. It remembers the last search.

You can use the command `:LogglySearch "my search query"` if you prefer.

# Mapping

You can create your own mapping if you want:

    map <leader>log <Plug>LogglySearch

You can also create maps for searches you do often:

    nnoremap <leader>errors :LogglySearch "json.level:ERROR"<cr>

# Settings

    let g:loggly_default_from = "-1h"
    let g:loggly_default_until = "now"
    let g:loggly_default_size = "100"

Find more using `:help loggly-search`

# Extending

You can call arbitrary code after the resut is returned in the buffer, e.g.:

    let g:loggly_filter = "call MyLogglyFilter()"
    
    function! MyLogglyFilter()
      " Keep only messages
      v/"message"/d
      %s/^ *"message": "//>
      %s/"$//>
    endfunction

# LICENSE

Copyright (c) 2016 Christian Rondeau, under [MIT license](LICENSE)
