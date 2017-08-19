" Jeff McCune <jeff@puppetlabs.com>
" 2010-07-28
" Vim customizations for Puppet Labs
" This should be useful for presentations, demos, and training.

set nocompatible
set nowrap
filetype plugin on
filetype indent on
syntax enable
" http://www.linux.com/archive/feature/120126
set statusline=%F%m%r%h%w\ [TYPE=%Y\ %{&ff}\ %{&fo}]\ [%l/%L,%v\ %p%%]\ [HEX=\%02.2B]
" Always show the status line
set laststatus=2
" Tabs and indentation (Default to two spaces)
set tabstop=2 "set tab character to 4 characters
set shiftwidth=2 "indent width for autoindent
set expandtab "turn tabs into whitespace
set smartindent
filetype indent on "indent depends on filetype

" JJM Enable line numbers, useful for discussion when on a projector
set number

" JJM Highlight extra white space.
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen

" Features supported on vim 7.3+
if v:version >= 703
  " Give an indicator when we approach col 80 (>72)
  au BufWinEnter * let w:m1=matchadd('Search', '\%<133v.\%>120v', -1)
  " Give a strong indicator when we exceed col 80(>80)
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>132v.\+', -1)
  " Give an indicator of tailing white space.
  au BufWinEnter * let w:m3=matchadd('ErrorMsg', '\s\+$', -1)
  " Give an indicator of spaces before a tab.
  au BufWinEnter * let w:m4=matchadd('ErrorMsg', ' \+\ze\t', -1)
endif

" Some distros disable this for security reasons
set modeline
set modelines=2
highlight Comment ctermfg=Green
set ignorecase
set incsearch
highlight Comment ctermfg=LightBlue
highlight LineNr ctermfg=black ctermbg=grey guifg=black guibg=grey

set diffexpr=MyDiff()
function MyDiff()
  let opt = ""
  if &diffopt =~ "icase"
    let opt = opt . "-i "
  endif
  if &diffopt =~ "iwhite"
    let opt = opt . "--ignore-all-space "
  endif
  silent execute "!diff -a --binary " . opt . v:fname_in . " " . v:fname_new .
        \  " > " . v:fname_out
endfunction

set diffopt+=iwhite

set mouse=a

"set t_Co=256
set background=dark
let g:solarized_termcolors=256

colorscheme solarized
let g:airline_powerline_fonts = 1
let g:airline_theme='wombat'
let g:airline#extensions#hunks#enabled = 0

autocmd StdinReadPre * let s:std_in=1
" Open NERDTree if no file specified
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Open NERDTree automatically when vim starts up on opening a directory
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
" Close vim if NERDTree is the last window open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

map <C-n> :NERDTreeToggle<CR>

if has('mouse_sgr')
  set ttymouse=sgr
endif

" match trailing spaces and tab characters
:match ExtraWhitespace /\s\+$\|\ze\t/

