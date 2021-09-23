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

call plug#end()

hi Normal guibg=NONE ctermbg=NONE
highlight Normal     ctermbg=NONE guibg=NONE
highlight LineNr     ctermbg=NONE guibg=NONE
highlight SignColumn ctermbg=NONE guibg=NONE
