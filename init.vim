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
"syntax on
augroup EditVim
  autocmd VimLeave * call system("xsel -ib", getreg('+'))
augroup END
set laststatus=0
set mouse=a
set number
set linebreak

"colorscheme Tomorrow-Night-Eighties

nnoremap <leader>r :sp<Bar>terminal%:p<cr><c-w>J
nnoremap <leader>j :%!jq<Enter>:set syntax=json<Enter>
nnoremap <Leader>w <C-w>
nnoremap <Leader>t :.w !zsh<Enter>
vnoremap <Leader>t :.w !sh<Enter>
nnoremap <Leader>s :%!sqlformat --reindent --keywords upper --identifiers lower - <Enter>


if exists('g:vscode')
  if has("clipboard")
    if has("unnamedplus")
      " When possible use + register for copy-paste
      set clipboard=unnamed,unnamedplus
    else
      " On mac and Windows, use * register for copy-paste
      set clipboard=unnamed
    endif
  endif
  inoremap <silent> <c-v> <Esc>:set paste<Cr>a<c-r>+<Esc>:set nopaste<Cr>a
    " VSCode extension
else
    " ordinary Neovim



call plug#begin()

"Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} 
"Plug 'terryma/vim-multiple-cursors'
"Plug 'vim-airline/vim-airline'
"Plug 'dracula/vim', { 'as': 'dracula' }
"Plug 'Houl/repmo-vim'
"Plug 'nvim-lua/plenary.nvim'
"Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
"Plug 'nvim-tree/nvim-web-devicons'
"Plug 'sindrets/diffview.nvim'




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


" nnoremap <leader>r :!%:p<Enter>
" nnoremap <leader>r :terminal%:p<Enter>


:let g:repmo_require_count = 1


:let g:go_imports_mode = 'goimports'

let $NVIM_TUI_ENABLE_TRUE_COLOR=1 
"set notermguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors

lua << EOF
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the four listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim", "help" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    -- disable = { },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    -- disable = function(lang, buf)
    --     local max_filesize = 100 * 1024 -- 100 KB
    --     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    --     if ok and stats and stats.size > max_filesize then
    --         return true
    --     end
    -- end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    --additional_vim_regex_highlighting = false,
  },
}
EOF


endif


autocmd BufEnter *.md colorscheme slate


colorscheme tokyonight-night
hi LineNr         ctermfg=228 ctermbg=none guifg=#6bbf54

