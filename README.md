# Vim Loggly Search

Searches for the visually selected text in [Loggly](https://www.loggly.com).

# Installation

## Prerequisites

Requies `curl` to be installed and in the `PATH`.

## Vundle

Use your preferred Vim plugin installation method. If you like [Vundle](https://github.com/VundleVim/Vundle.vim):

Add to your `.vimrc`:

    Plugin 'christianrondeau/vim-loggly-search'

And install it:

    :so ~/.vimrc
    :PluginInstall

# Usage

Type `<leader>loggly` in visual mode to start a search and show results in a new split buffer.
