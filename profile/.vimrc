set nocompatible              " be iMproved

call plug#begin()

" custom plugins
Plug 'fatih/vim-go'
Plug 'majutsushi/tagbar'
Plug 'shougo/neocomplete.vim'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'bling/vim-airline'
Plug 'tpope/vim-fugitive'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'mbbill/undotree'
Plug 'Lokaltog/vim-easymotion'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-git'
Plug 'ekalinin/Dockerfile.vim'
Plug 'plasticboy/vim-markdown'
Plug 'rhysd/vim-gfm-syntax'
Plug 'MTDL9/vim-log-highlighting'
Plug 'Shougo/defx.nvim'
Plug 'mbbill/undotree'
Plug 'reedes/vim-wordy'
Plug 'brooth/far.vim'
Plug 'Shougo/vinarise.vim'
Plug 'mzlogin/vim-markdown-toc'
Plug 'sheerun/vim-polyglot'



" all of your Plugins must be added before the following line
call plug#end()            " required

" general customizations
syntax on
set ts=4
set sw=4
set number
set cursorline
set scrolloff=999
set encoding=utf-8
colorscheme molokai
" Flash screen instead of beep sound
set visualbell
" Set the encoding of files written
set fileencoding=utf-8
set backspace=indent,eol,start

" plugin customizations
" neocomplete
let g:neocomplete#enable_at_startup = 1

" vim go
" disable open browser after posting snippet
let g:go_play_open_browser = 0
" enable goimports
let g:go_fmt_command = "goimports"
" enable additional highlighting
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1

" vim-airline
set laststatus=2
let g:bufferline_echo = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'dark'

autocmd Filetype go setlocal tabstop=4 shiftwidth=4 softtabstop=4
" tagbar
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds' : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

" Status line types/signatures.
let g:go_auto_type_info = 1

" shortcuts remap
nmap <F2> :tabnew<CR>
nmap <F3> :tabclose<CR>
nmap <F5> :UndotreeToggle<CR>
nmap <F7> :NERDTreeTabsToggle<CR>
nmap <F8> :TagbarToggle<CR>
nmap <C-Left> :tabprevious<CR>
nmap <C-Right> :tabnext<CR>

" show a list of interfaces which is implemented by the type under your cursor
au FileType go nmap <Leader>s <Plug>(go-implements)
" show type info for the word under your cursor
au FileType go nmap <Leader>gi <Plug>(go-info)
" open the relevant Godoc for the word under the cursor
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
" run Go commands
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage)
au FileType go nmap <leader>i <Plug>(go-install)
" open the definition/declaration in a new vertical, horizontal or tab for the
" word under your cursor
au FileType go nmap <Leader>ds <Plug>(go-def-split)
au FileType go nmap <Leader>dv <Plug>(go-def-vertical)
au FileType go nmap <Leader>dt <Plug>(go-def-tab)
" rename the identifier under the cursor to a new name
au FileType go nmap <Leader>e <Plug>(go-rename)


" NERDTree plugin specific commands
:nnoremap <C-g> :NERDTreeToggle<CR>
autocmd vimenter * NERDTree


" air-line plugin specific commands
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''