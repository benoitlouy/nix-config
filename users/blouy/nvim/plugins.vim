set termguicolors

" Highlighting for jsonc filetype
autocmd FileType json syntax match Comment +\/\/.\+$+

" EasyMotion search with highlighting
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

" vim-scala
au BufRead,BufNewFile *.sbt,*.sc set filetype=scala

" Nerd commenter
filetype plugin on

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Rainbow Parentheses
let g:rainbow_active = 1

" neoclip
:lua require("sqlite")
:lua require('neoclip').setup({ enable_persistent_history = true })
:lua require('telescope').load_extension('neoclip')
nnoremap <leader>p :Telescope neoclip<cr>

:lua require("tree-sitter-config")
