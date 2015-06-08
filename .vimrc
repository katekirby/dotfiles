set exrc
set showmode
set background=light
set backspace=indent,eol,start
set tabstop=4
set ai
set ruler
syntax on
"colors darkblue

autocmd BufNewFile,Bufread *.t set filetype=perl
autocmd BufNewFile,Bufread *.mm set filetype=perl

"===[ Automatically resource .vimrc on changes ]==
augroup VimReload
autocmd!
	autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

"====[ Use persistent undo ]=================

if has('persistent_undo')
    " Save all undo files in a single location (less messy, more risky)...
    set undodir=$HOME/tmp/.VIM_UNDO_FILES

    " Save a lot of back-history...
    set undolevels=5000

    " Actually switch on persistent undo
    set undofile

endif

"====[ Goto last location in non-empty files ]=======

autocmd BufReadPost *  if line("'\"") > 1 && line("'\"") <= line("$")
                   \|     exe "normal! g`\""
                   \|  endif

"====[ Set up smarter search behaviour ]=======================

set incsearch       "Lookahead as search pattern is specified
set ignorecase      "Ignore case in all searches...
set smartcase       "...unless uppercase letters used

set hlsearch        "Highlight all matches
highlight clear Search
highlight       Search    ctermfg=White

"Delete in normal mode switches off highlighting till next search...
nmap <silent> <BS> :nohlsearch

"=======[ Fix smartindent stupidities ]============

set autoindent                              "Retain indentation on next line
set smartindent                             "Turn on autoindenting of blocks

inoremap # X<C-H>#|                         "And no magic outdent for comments
nnoremap <silent> >> :call ShiftLine()<CR>| "And no shift magic on comments

function! ShiftLine()
    set nosmartindent
    normal! >>
    set smartindent
endfunction

"=====[ Make Visual modes work better ]==================

"Square up visual selections...
set virtualedit=block

" Make BS/DEL work as expected in visual modes (i.e. delete the selected text)...
vmap <BS> x

"=====[ Remap space key to something more useful ]========================

" Use space to jump down a page (like browsers do)...
nnoremap <Space> <PageDown>

"=====[ Show help files in a new tab ]==============

"Only apply to .txt files...
augroup HelpInTabs
    autocmd!
    autocmd BufEnter  *.txt   call HelpInNewTab()
augroup END

"Only apply to help files...
function! HelpInNewTab ()
    if &buftype == 'help' && g:help_in_tabs
        "Convert the help window to a tab...
        execute "normal \<C-W>T"
    endif
endfunction


"=====[ Show the column marker in visual insert mode ]====================

vnoremap <silent>  I  I<C-R>=TemporaryColumnMarkerOn()<CR>
vnoremap <silent>  A  A<C-R>=TemporaryColumnMarkerOn()<CR>

function! TemporaryColumnMarkerOn ()
	set cursorcolumn
	inoremap <silent>  <ESC>  <ESC>:call TemporaryColumnMarkerOff()<CR>
	return ""
endfunction

function! TemporaryColumnMarkerOff ()
	set nocursorcolumn
	iunmap <ESC>
endfunction
