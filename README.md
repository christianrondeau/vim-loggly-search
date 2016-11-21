# Vim Loggly Search

Searches for the visually selected text in [Loggly](https://www.loggly.com).

# Installation

## Prerequisites

* A [Loggly](https://www.loggly.com) account
* Requires `curl` to be installed and in the `PATH`.

## Plugin

Use your preferred Vim plugin installation method. If you like [Vundle](https://github.com/VundleVim/Vundle.vim):

Add to your `.vimrc`:

    Plugin 'christianrondeau/vim-loggly-search'

And install it:

    :so ~/.vimrc
    :PluginInstall

## Basic Configuration

You also need to assign these variables in your `.vimrc`:

    " Your <account>.loggly.com
    let g:loggly_account = "account_name"

    " Either:
    "  * --netrc-file path-to-netrc-file
    "  * -u username
    "  * -u username:password
    let g:loggly_curl_auth = "--netrc-file ~/.netrc"

## Windows

* Install [cURL](https://curl.haxx.se/) and make sur it's in your `PATH`
* Download https://curl.haxx.se/ca/cacert.pem as `curl-ca-bundle.crt`, and put it somewhere available in your `PATH`

# Usage

Type `<leader>loggly` in visual mode to start a search and show results in a new split buffer.

When *not* in visual mode, it will remember your last search.

You can also call the `loggly#search` function, e.g. in your own mappings:

    nnoremap <leader>errors :call loggly#search("json.level:ERROR")<cr>

# Settings

    let g:loggly_default_from = "-1h"
    let g:loggly_default_until = "now"
    let g:loggly_default_size = "10"

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
