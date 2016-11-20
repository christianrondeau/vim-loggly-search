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
    "  * --netrc-file my-password-file
    "  * -u username
    "  * -u username:password
    let g:loggly_curl_auth = "--netrc-file my-password-file ~/.loggly_netrc"

## Windows

* Install [cURL](https://curl.haxx.se/) and make sur it's in your `PATH`
* Make sure cURL is configured to accept HTTPS ([see instructions here](http://support.gnip.com/articles/curl-on-win7.html))

# Usage

Type `<leader>loggly` in visual mode to start a search and show results in a new split buffer.

When *not* in visual mode, it will remember your last search.

# Settings

    let g:loggly_default_from = "-1h"
    let g:loggly_default_until = "now"
    let g:loggly_default_size = "10"

Find more using `:help loggly-search`
