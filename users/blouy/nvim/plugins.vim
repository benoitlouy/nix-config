set termguicolors
colorscheme monokai_pro

" vim-airline
let g:airline_powerline_fonts=1
let g:airline_theme = 'powerlineish'

let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'


" Highlighting for jsonc filetype
autocmd FileType json syntax match Comment +\/\/.\+$+

" EasyMotion search with highlighting
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

" vim-scala
au BufRead,BufNewFile *.sbt,*.sc set filetype=scala

" Nerdtree
map <C-F> :NERDTreeToggle<CR>
map <C-S> :NERDTreeFind<CR>

let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1

" Nerd commenter
filetype plugin on

" Nerdtree git plugin symbols
let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ "Modified"  : "ᵐ",
    \ "Staged"    : "ˢ",
    \ "Untracked" : "ᵘ",
    \ "Renamed"   : "ʳ",
    \ "Unmerged"  : "ᶴ",
    \ "Deleted"   : "ˣ",
    \ "Dirty"     : "˜",
    \ "Clean"     : "ᵅ",
    \ "Unknown"   : "?"
    \ }

" Fuzzy finder shortcut
nnoremap <C-p> :FZF<CR>

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

let g:lightline = { 'colorscheme': 'monokai_pro' }

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Rainbow Parentheses
let g:rainbow_active = 1