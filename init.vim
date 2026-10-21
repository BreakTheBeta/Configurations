filetype on                   " required for compatibility with Mac OS X, See issue #167
filetype off
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
"augroup EditVim
"  autocmd VimLeave * call system("xsel -ib", getreg('+'))
augroup END
set laststatus=0
set mouse=a
set number
set linebreak

"colorscheme Tomorrow-Night-Eighties

nnoremap <leader>r :sp<Bar>terminal%:p<cr><c-w>J
nnoremap <leader>f :%w !zsh<Enter>
nnoremap <leader>j :%!jq<Enter>:set syntax=json<Enter>
nnoremap <Leader>w <C-w>
nnoremap <Leader>t :.w !zsh<Enter>
vnoremap <Leader>t :.w !sh<Enter>
vnoremap <Leader>t :.w !sh<Enter>
nnoremap <Leader>s :%!sqlformat --reindent --keywords upper --identifiers lower - <Enter>

" Gen ai commands
nnoremap <Leader>g :Gen

xnoremap <Leader>ge :Gen Elaborate_Text<Enter>
xnoremap <Leader>gf :Gen Spell_Grammar_V2<Enter>


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

Plug 'nvim-treesitter/nvim-treesitter', {'commit': '55ae57419504432ba9c229ea9b03bad621ab9ef7', 'do': ':TSUpdate'}
Plug 'terryma/vim-multiple-cursors', {'commit': '6456718e1d30b42c04b920c5413ca44f68f08759'}
Plug 'dracula/vim', {'commit': '65f4225e0526516a67d56c8ac09925a209138e53', 'as': 'dracula'}
Plug 'Houl/repmo-vim', {'commit': 'b2721c7a7e26fb6191e6307e32c23a43a90c88a9'}
Plug 'nvim-lua/plenary.nvim', {'commit': '3707cdb1e43f5cea73afb6037e6494e7ce847a66'}
Plug 'folke/tokyonight.nvim', {'commit': 'dca4adba7dc5f09302a00b0e76078d54d82d2658'}
Plug 'nvim-tree/nvim-web-devicons', {'commit': '402377242b04be3f4f0f3720bd952df86e946c30'}
Plug 'sindrets/diffview.nvim', {'commit': '4516612fe98ff56ae0415a259ff6361a89419b0a'}
Plug 'vim-scripts/LargeFile', {'commit': '3941a37b2b0288524300348a39521a46539bf9f6'}
Plug 'David-Kunz/gen.nvim', {'commit': 'e09a8dbffa139ad60d5b47998fcc8669ead1ebf4'}
Plug 'HiPhish/nvim-ts-rainbow2', {'commit': 'b3120cd5ae9ca524af9cb602f41e12e301fa985f'}


Plug 'nvim-lualine/lualine.nvim', {'commit': '2a5bae925481f999263d6f5ed8361baef8df4f83'}
" If you want to have icons in your statusline choose one of these


" Plug 'vim-airline/vim-airline'
"
"
"Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
"Plug 'danilo-augusto/vim-afterglow'
"Plug 'sonph/onehalf', {'rtp': 'vim/'}
"Plug 'pangloss/vim-javascript'    " JavaScript support
"Plug 'leafgarland/typescript-vim' " TypeScript syntax
"Plug 'maxmellon/vim-jsx-pretty'   " JS and JSX syntax
"Plug 'jparise/vim-graphql'        " GraphQL syntax
"Plug 'hashivim/vim-terraform'
"Plug 'vim-airline/vim-airline'
"Plug 'jacquesbh/vim-showmarks'
"Plug 'uiiaoo/java-syntax.vim'
"
"
"Plug 'google/vim-maktaba'
"Plug 'chriskempson/tomorrow-theme'
"Plug 'elzr/vim-json'
"Plug 'fatih/vim-go'
"Plug 'Houl/repmo-vim'
"Plug 'vim-scripts/Visual-Mark'
"Plug 'ellisonleao/glow.nvim'
"Plug 'nvim-lua/plenary.nvim'
"Plug 'sindrets/diffview.nvim'
"Plug 'catppuccin/nvim', { 'as': 'catppuccin' }


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
if not pcall(require, 'lualine') or not pcall(require, 'nvim-treesitter.configs') or not pcall(require, 'gen') then
  return
end
require('lualine').setup()

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the four listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!
  --rainbow = {
  --  enable = true,
  --  -- list of languages you want to disable the plugin for
  --  disable = { 'jsx', 'cpp' },
  --  -- Which query to use for finding delimiters
  --  query = 'rainbow-parens',
  --  -- Highlight the entire buffer all at once
  --  strategy = require('ts-rainbow').strategy.global,
  --},

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


require('gen').setup({
  -- same as above
        model = "dolphin-llama3:70b", -- The default model to use.
        host = "localhost", -- The host running the Ollama service.
        port = "11434", -- The port on which the Ollama service is listening.
        quit_map = "q", -- set keymap for close the response window
        retry_map = "<c-r>", -- set keymap to re-send the current prompt
        init = function(options) pcall(io.popen, "ollama serve > /dev/null 2>&1 &") end,
        -- Function to initialize Ollama
        command = function(options)
            local body = {model = options.model, stream = true}
            return "curl --silent --no-buffer -X POST http://" .. options.host .. ":" .. options.port .. "/api/chat -d $body"
        end,


        -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
        -- This can also be a command string.
        -- The executed command must return a JSON object with { response, context }
        -- (context property is optional).
        -- list_models = '<omitted lua function>', -- Retrieves a list of model names
        display_mode = "float", -- The display mode. Can be "float" or "split".
        show_prompt = true, -- Shows the prompt submitted to Ollama.
        show_model = false, -- Displays which model you are using at the beginning of your chat session.
        no_auto_close = true, -- Never closes the window automatically.
        debug = false -- Prints errors and the command which is run.
})

require('gen').prompts['Elaborate_Text'] = {
  prompt = "Please continue the following text text:\n$text",
  replace = false
}

require('gen').prompts['Spell_Grammar_V2'] = {
  prompt = "Modify the following text to improve grammar and spelling, if it's markdown keep the markdown. Just output the final text without additional quotes around it: :\n$text",
  replace = true
}



-- require("gen").prompts["con"] = {
--       prompt = "Please repeat the text and continue it keeping to the theme. Ouput the old text without additonal quotes around it: ```$filetype\n...\n```:\n```$filetype\n$text\n```",
--       replace = true,
--       extract = "```$filetype\n(.-)```",
--     }

EOF


endif


autocmd BufEnter *.md colorscheme slate


silent! colorscheme tokyonight-night
hi LineNr         ctermfg=228 ctermbg=none guifg=#6bbf54
hi MatchParen cterm=none ctermbg=green ctermfg=blue
hi MatchParen         ctermfg=228 ctermbg=none guifg=#6bbf54


set cmdheight=0
set tabstop=2
set shiftwidth=2
set expandtab
highlight MatchParen ctermbg=lightgray ctermfg=black guibg=black guifg=white
hi MatchParen ctermbg=lightgray ctermfg=black guibg=black guifg=white
autocmd VimEnter * highlight MatchParen ctermbg=lightgray ctermfg=black guibg=black guifg=white



" Presentation Mode
noremap <Left> :silent bp<CR> :redraw!<CR>
noremap <Right> :silent bn<CR> :redraw!<CR>
nmap <f5> :set number! laststatus=0<CR>

" Make assci art
vnoremap <leader>f :!toilet -w 200 -f Cybermedium<CR>
