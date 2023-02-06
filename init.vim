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
set linebreak

colorscheme Tomorrow-Night-Eighties


call plug#begin()

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} 
Plug 'danilo-augusto/vim-afterglow'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'pangloss/vim-javascript'    " JavaScript support
Plug 'leafgarland/typescript-vim' " TypeScript syntax
Plug 'maxmellon/vim-jsx-pretty'   " JS and JSX syntax
Plug 'jparise/vim-graphql'        " GraphQL syntax
Plug 'hashivim/vim-terraform'
Plug 'vim-airline/vim-airline'
Plug 'jacquesbh/vim-showmarks'
Plug 'uiiaoo/java-syntax.vim'


Plug 'google/vim-maktaba'
Plug 'chriskempson/tomorrow-theme'
Plug 'elzr/vim-json'
Plug 'fatih/vim-go'
Plug 'Houl/repmo-vim'
Plug 'vim-scripts/Visual-Mark'
Plug 'ellisonleao/glow.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'sindrets/diffview.nvim'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }


call plug#end()


" colorscheme catppuccin-mocha

let g:afterglow_inherit_background=1 
let g:afterglow_blackout=1

" Add repeat motions for up and down movement when using a multiplier

" map a motion and its reverse motion:
:noremap <expr> h repmo#SelfKey('h', 'l')|sunmap h
:noremap <expr> l repmo#SelfKey('l', 'h')|sunmap l

" if you like `:noremap j gj', you can keep that:
:noremap <expr> j repmo#Key('gj', 'gk')|sunmap j
:noremap <expr> k repmo#Key('gk', 'gj')|sunmap k

" repeat the last [count]motion or the last zap-key:
:map <expr> ; repmo#LastKey(';')|sunmap ;
:map <expr> , repmo#LastRevKey(',')|sunmap ,

" add these mappings when repeating with `;' or `,':
:noremap <expr> f repmo#ZapKey('f')|sunmap f
:noremap <expr> F repmo#ZapKey('F')|sunmap F
:noremap <expr> t repmo#ZapKey('t')|sunmap t
:noremap <expr> T repmo#ZapKey('T')|sunmap T



"nnoremap <leader>r :split<Enter>
" Leader meta
nnoremap <leader>r :sp<Bar>terminal%:p<cr><c-w>J
nnoremap <leader>j :%!jq<Enter>:set syntax=json<Enter>
nnoremap <Leader>w <C-w>
":terminal%:p<Enter>:close

" nnoremap <leader>r :!%:p<Enter>
" nnoremap <leader>r :terminal%:p<Enter>


:let g:repmo_require_count = 1

" Theme that works well for a transparent theme, even against white
" backgrouond
" hi Comment        ctermfg=66 cterm=italic
" hi MatchParen ctermbg=54
" hi Comment        ctermfg=40
" hi Number ctermfg=199
" hi link Float Number
" hi link Boolean Number
" hi StorageClass   ctermfg=208
 hi Statement      ctermfg=205 ctermbg=none
 hi LineNr         ctermfg=228 ctermbg=none
 hi Visual         ctermbg=40 ctermfg=52


" Diff Tool highlighting

 hi DiffDelete ctermbg=52 ctermfg=53
 hi DiffChange ctermbg=65 ctermfg=66
 hi DiffText ctermbg=67 ctermfg=69
 hi DiffRemoved ctermbg=70 ctermfg=71
 hi DiffAdd ctermbg=72 ctermfg=73


" hi Visual         cterm=underline
" hi Constant       ctermfg=178
" hi String         ctermfg=213 
" hi SpellBad       cterm=underline ctermbg=52
 hi Title          ctermfg=154

" Change the spell check 
hi clear SpellBad
hi SpellBad cterm=underline

