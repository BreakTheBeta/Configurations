set tabstop=2
set shiftwidth=2
set expandtab
nnoremap <C-y> "+y
vnoremap <C-y> "+y
nnoremap <C-p> "+gP
vnoremap <C-p> "+gP
nnoremap j gj
nnoremap gj j
nnoremap k gk
nnoremap gk k
filetype plugin on
syntax on
autocmd VimLeave * call system("xsel -ib", getreg('+'))
set laststatus=0
set mouse=a
set number

let g:afterglow_inherit_background=1 
let g:afterglow_blackout=1

call plug#begin()

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} 
Plug 'danilo-augusto/vim-afterglow'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'pangloss/vim-javascript'    " JavaScript support
Plug 'leafgarland/typescript-vim' " TypeScript syntax
Plug 'maxmellon/vim-jsx-pretty'   " JS and JSX syntax
Plug 'jparise/vim-graphql'        " GraphQL syntax

call plug#end()

" Theme that works well for a transparent theme, even against white
" backgrouond
hi Comment        ctermfg=66 cterm=italic
hi MatchParen ctermbg=54
hi Comment        ctermfg=40
hi Number ctermfg=199
hi link Float Number
hi link Boolean Number
hi Statement      ctermfg=205 ctermbg=none
hi StorageClass   ctermfg=208
hi LineNr         ctermfg=228 ctermbg=none
hi Constant       ctermfg=178
hi String         ctermfg=213 
