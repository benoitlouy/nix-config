set encoding=utf-8

set relativenumber

set splitbelow
set splitright

nmap <Leader>- :split<CR>
nmap <Leader>\| :vsplit<CR>

" Clear search highlighting
nnoremap <C-z> :nohlsearch<CR>

" Use \\ to switch between buffers
nnoremap <Leader><Leader> :b#<CR>

nmap <Leader>b :Buffers<CR>

set clipboard=unnamed

syntax on
set backspace=2
set laststatus=2
set noshowmode

" Tabs as spaces
set expandtab     " Tab transformed in spaces
set tabstop=2     " Sets tab character to correspond to x columns.
                  " x spaces are automatically converted to <tab>.
                  " If expandtab option is on each <tab> character is converted to x spaces.
set softtabstop=2 " column offset when PRESSING the tab key or the backspace key.
set shiftwidth=2  " column offset when using keys '>' and '<' in normal mode.

" Trim whitespace function
function! TrimWhitespace()
    let l:save_cursor = getpos('.')
    %s/\s\+$//e
    call setpos('.', l:save_cursor)
endfun

command! TrimWhitespace call TrimWhitespace() " Trim whitespace with command
autocmd BufWritePre * :call TrimWhitespace()  " Trim whitespace on every save

" General editor options
set hidden                         " Hide files when leaving them.
set number                         " Show line numbers.
set numberwidth=1                  " Minimum line number column width.
set cmdheight=2                    " Number of screen lines to use for the commandline.
set textwidth=0                    " Lines length limit (0 if no limit).
set formatoptions=jtcrq            " Sensible default line auto cutting and formatting.
set linebreak                      " Don't cut lines in the middle of a word .
set showmatch                      " Shows matching parenthesis.
set matchtime=2                    " Time during which the matching parenthesis is shown.
set list listchars=tab:▸\ ,trail:· " Invisible characters representation when :set list.
set clipboard=unnamedplus          " Copy/Paste to/from clipboard
set cursorline                     " Highlight line cursor is currently on
" set completeopt+=noinsert          " Select the first item of popup menu automatically without inserting it

" Search
set incsearch  " Incremental search.
set ignorecase " Case insensitive.
set smartcase  " Case insensitive if no uppercase letter in pattern, case sensitive otherwise.
set nowrapscan " Don't go back to first match after the last match is found.

" Create directories when saving file
function s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction
augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END

autocmd FileType sbt setlocal commentstring=//\ %s

set wildmode=longest:full,full

augroup quickfix
    autocmd!
    autocmd FileType qf setlocal wrap
augroup END
