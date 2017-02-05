# Common User Access cut, copy, and paste for Vim

`cuaccp.vim` provides CUA-style cut, copy, and paste in Vim.

## Rationale

The default keybindings Vim provides for copying and pasting are quite
cumbersome: in normal mode, actions involving the clipboard must be prefixed by
`"+`. In insert mode, Vim provides several keybindings, but these all have
problems: `<C-R>+` (interprets control characters, so unsafe), `<C-R><C-R>+`
(inserts linebreaks), `<C-R><C-O>+` (when the cursor is between two quote
marks, can paste outside of those quote marks), `<C-R><C-P>+` (again, this can
paste outside of quote marks); each of these is also cumbersome to type.

This plugin attempts to simplify accessing the clipboard in the spirit of
`mswin.vim`, which is included (but not loaded) in stock Vim. `mswin.vim`
itself is not suitable because it goes beyond mappings that deal with the
clipboard.

## Installation

The plugin works with the major plugin managers. For instance with
[vim-plug][plug] just place in your `.vimrc`:

    Plug 'riceissa/vim-cuaccp'

## License

Distributed under the same terms as Vim itself. See `:help license`.

[plug]: https://github.com/junegunn/vim-plug
