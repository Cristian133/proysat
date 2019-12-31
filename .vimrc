"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mantiene:
"           Cristian Andrione
"           cristian.andrione@gmail.com
"
" Codebase:
"           Amir Salihefendic
"           http://amix.dk - amix@amix.dk
"
" Version:
"           1.0 - 28/12/2019
"
" Sections:
"           -> General
"           -> VIM user interface
"           -> Colors and Fonts
"           -> Visual
"           -> Parenthesis/bracket
"           -> Text, tab and indent related
"           -> Files, backups and undo
"           -> Helpers funtions
"           -> Editing mappings
"           -> Moving around, tabs and buffers
"           -> Blank space treatments
"           -> Spell checking
"           -> Status line
"           -> File types
"           -> Vimdiff
"           -> Vimgrep
"           -> Tags
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" This changes the values of a LOT of options, enabling features
" which are not Vi compatible but really nice.
set nocompatible

" Set the default shell
set shell=bash

" Disable unsafe commands
set secure

" Disable modelines as a security precaution
set modelines=0
set nomodeline

" Enable filetype detection.
filetype on

" Enable filetype-specific plugins
filetype plugin on

" Enable filetype-specific indenting
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" Change leader from backslash to comma
" That means all \x commands turn into ,x
let mapleader = ","
let g:mapleader = ","

" Sets how many lines of history VIM has to remember
set history=1000

" Tell us about changes.
set report=0

" Manage your 'runtimepath'
execute pathogen#infect()

" NerdTree shows hidden files
let NERDTreeShowHidden=1


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set lines to the cursor - when moving vertically using j/k or Up/Down
set so=0

" Show line numbers or current line number
" in combination with relativenumber
set number

" Command bar height
set cmdheight=1

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Automatically wrap left and righ.
set whichwrap=b,s,h,l,<,>,[,]

" Turn off the bell
set noerrorbells
set novisualbell

" Add extra margin to the left
set foldcolumn=0

" Ignore case when searching
set ignorecase

" Use intelligent case while searching.
" (If search string contains an upper case letter, disable ignorecase.)
set smartcase

" Also switch on highlighting the last used search pattern
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" For regular expressions turn magic on
set magic

" Highlight current line
set cursorline

" Split vertically to the right.
set splitright

" Split horizontally below.
set splitbelow

" Do not reset cursor to start of line when moving around.
set nostartofline


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Turn on color syntax highlight
syntax enable

try
	colorscheme hybrid
catch
endtry

set background=dark

" Set encoding
set encoding=utf8

" Try to detect file formats.
" Unix for new files and autodetect for the rest.
set fileformats=unix,dos,mac


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Visual
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Parenthesis/bracket
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Show matching brackets when text indicator is over them.
set showmatch

" Include angle brackets in matching.
set matchpairs+=<:>

" How many tenths of a second to blink when matching brackets.
set mat=2


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Expand tabs to spaces.
set expandtab

" Be smart when using tabs.
set smarttab

" Linebreak on 79 characters
"set linebreak
"set textwidth=79

set autoindent "Auto indent
set smartindent "Smart indent
set wrap "Wrap lines

" Number of spaces to use for each step of indent.
set shiftwidth=4
set tabstop=4

" None word dividers
set isk+=_,$,@,%,#,-

" Invisible characters
set showbreak=↪\
set listchars=tab:→\ ,eol:↲,nbsp:␣,trail:•,extends:»,precedes:«,space:.

" Highlight conflict markers.
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set swapfile
set directory=~/.vim/swaps

set backup
set writebackup
set backupdir=~/.vim/backups

set undofile
set undodir=~/.vim/undo


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helpers functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"Do not close window when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
	let l:currentBufNum = bufnr("%")
	let l:alternateBufNum = bufnr("#")

	if buflisted(l:alternateBufNum)
		buffer #
	else
		bnext
	endif

	if bufnr("%") == l:currentBufNum
		new
	endif

	if buflisted(l:currentBufNum)
		execute("bdelete! ".l:currentBufNum)
	endif
endfunction

" current buffer size
function! FileSize()
    let bytes = getfsize(expand("%:p"))
    if bytes <= 0
        return ""
    endif
    if bytes < 1024
        return bytes
    else
        return (bytes / 1024) . "K"
    endif
endfunction

" highlight text from column 80
let s:activatedh = 0
function! ToggleH()
    if s:activatedh == 0
        let s:activatedh = 1
        match Search '\%80v.\+'
    else
        let s:activatedh = 0
        match none
    endif
endfunction

" number or relativenumber
function! ToggleNumber()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunc

" hexadecimal
let s:activatehex = 0
function! ToggleHex()
    if s:activatehex == 0
        let s:activatehex = 1
        :%!xxd
    else
        let s:activatedhex = 0
        :%!xxd -r
    endif
endfunction

"Toggle wrap - nowrap (líneas reales - líneas visibles)
let s:activatewrap = 0
function! ToggleWrap()
    if s:activatewrap == 0
        let s:activatewrap = 1
        set nowrap
    else
        let s:activatewrap = 0
        set wrap
    endif
endfunction

"Get git branch and status of edited file
function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

" returns a string <branch/XX> where XX corresponds to the git status
" (for example "<master/ M>")
function CurrentGitStatus()
    let gitoutput = split(system('git status --porcelain -b '.shellescape(expand('%')).' 2>/dev/null'),'\n')
    if len(gitoutput) > 0
        let b:gitstatus = strpart(get(gitoutput,0,''),3) . '/' . strpart(get(gitoutput,1,'  '),0,2)
    else
        let b:gitstatus = ''
    endif
endfunc
autocmd BufEnter,BufWritePost * call CurrentGitStatus()

function Highlight_Statusline()
  hi User1            ctermfg=Yellow  cterm=bold
endfunction

autocmd ColorScheme * call Highlight_Statusline()
autocmd BufEnter * call Highlight_Statusline()

function! WindowNumber()
  return tabpagewinnr(tabpagenr())
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" =>  Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" tnoremap only terminal mode
tnoremap <Esc> <C-\><C-n>

map <leader>1 :call ToggleH()<CR>
map <leader>2 :call ToggleNumber()<CR>
map <leader>3 :call ToggleCol80()<CR>
map <leader>4 :call ToggleHex()<CR>
map <leader>5 :call ToggleWrap()<CR>
map <leader>6 $D
imap <leader>6 <Esc>$D

" Yank and put system pasteboard with <Leader>y/p.
nnoremap <silent> <leader>p "+p
nnoremap <silent> <leader>y "+y
nnoremap <silent> <leader>Y "+y$

" Yank to end of line
map Y y$

map <F4> :buffers<CR>:buffer<Space>
map <F5> :NERDTreeToggle<CR>
map <F6> :Bclose<CR>

" syntax-check
map <F7> :make <CR>

" tags work directory
map <F8> :!ctags -R<CR>

" buffer tex to pdf file
map <F9> :w!<CR>:call Build()<CR>
imap <F9> <Esc>:w!<CR>:call Built()<CR>

" :W sudo saves the file
" (useful for handling the permission-denied error)
command W w !sudo tee % > /dev/null

" gi moves to last insert mode (default)
" gI moves to last modification
nnoremap gI `.

" Map <Space> to / (search) and Ctrl-<Space> to ? (backwards search).
map <space> /
map <C-space> ?

" Fast saving
map <leader>w :w!<cr>

nmap <leader>l :set list!<CR>

" Close the current buffer
map <leader>bd :Bclose<cr>:tabclose<cr>gT

" Close all the buffers
map <leader>ba :bufdo bd<cr>

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" open .vimrc
map <leader>e :e ~/.vimrc<CR>

" Disable highlight when <leader><CR> is pressed
map <silent> <leader><CR> :noh<CR>

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" buffers
map <leader><right> :bnext<cr>
map <leader><left>  :bprevious<cr>

" windows
map <C-up>    <C-W>k
map <C-down>  <C-W>j
map <C-left>  <C-W>h
map <C-right> <C-W>l

" Move a line of text using ALT+[jk] or ALT+[Up-Down]
nmap <M-Up> mz:m-2<cr>`z
nmap <M-Down> mz:m+<cr>`z
vmap <M-Up> :m'<-2<cr>`>my`<mzgv`yo`z
vmap <M-Down> :m'>+<cr>`<my`>mzgv`yo`z


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Blank space treatments
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"Highlight spaces at the end of the line
if has('autocmd')
    highlight ExtraWhitespace ctermbg=1 guibg=red
    match ExtraWhitespace /\s\+$/
endif

" Strip trailing whitespace
map <F10> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
imap <F10> <Esc>:let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spelling checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Toggle <,ss> spell checking
"setlocal spell spelllang=es
map <leader>ss :setlocal spell spelllang=es<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Status line
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Always show the status line
set laststatus=2

set statusline=%f
set statusline+=\ \ 
set statusline+=%1*%(\[%{b:gitstatus}]%)%*
set statusline+=%=
set statusline+=Buffer:
set statusline+=\[%n%H%M%R%W]\ 
set statusline+=\ \ 
set statusline+=FileType:
set statusline+=\%y
set statusline+=\ \ 
"set statusline+=size:
"set statusline+=\[%{FileSize()}]
"set statusline+=\ \ 
set statusline+=Cursor:
set statusline+=\[\%3l
set statusline+=/ 
set statusline+=\%2c\]
set statusline+=\ \ 
set statusline+=Total:
set statusline+=\[\%3L
set statusline+=\ lines\]
set statusline+=\ 


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File types
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" automatic commands
if has("autocmd")
  " file type detection

  " FORTH
  au BufRead,BufNewFile  *.fth,*.FTH,*.fs,*.FS,*.ft,*.FT set filetype=forth

  " Ruby
  au BufRead,BufNewFile *.rb,*.rbw,*.gem,*.gemspec set filetype=ruby

  " markdown
  au BufRead,BufNewFile *.md,*.markdown,*.ronn     set filetype=markdown

  " special text files
  au BufRead,BufNewFile *.rtxt         set filetype=html spell
  au BufRead,BufNewFile *.stxt         set filetype=markdown spell

  au BufRead,BufNewFile *.sql        set filetype=pgsql

  au BufRead,BufNewFile *.rl         set filetype=ragel

  au BufRead,BufNewFile *.svg        set filetype=svg

  au BufRead,BufNewFile *.haml       set filetype=haml

  " aura cmp files
  au BufRead,BufNewFile *.cmp        set filetype=html

  au Filetype gitcommit                setlocal tw=68 spell fo+=t nosi
  au BufNewFile,BufRead COMMIT_EDITMSG setlocal tw=68 spell fo+=t nosi

  " ruby
  au Filetype ruby                   set tw=80

  " allow tabs on makefiles
  au FileType make                   setlocal noexpandtab
  au FileType go                     setlocal noexpandtab

  " set makeprg(depends on filetype) if makefile is not exist
  if !filereadable('makefile') && !filereadable('Makefile')
    au FileType c                    setlocal makeprg=gcc\ %\ -o\ %<
    au FileType sh                   setlocal makeprg=bash\ -n\ %
  endif
endif

" automatic commands
if has("autocmd")
  " allow tabs on makefiles
  au FileType make setlocal noexpandtab
endif

" statusline color
function! ColourStatusLineFileType()
    filetype detect
    if &filetype == 'ruby'
        setlocal expandtab shiftwidth=2 tabstop=2
        hi StatusLine ctermbg=grey ctermfg=235
    elseif &filetype == 'forth'
        setlocal expandtab shiftwidth=2 tabstop=2
        hi StatusLine ctermbg=grey ctermfg=235
    elseif &filetype == 'python'
        setlocal expandtab shiftwidth=4 tabstop=4
        hi StatusLine ctermbg=grey ctermfg=235
    elseif &filetype == 'c'
        setlocal expandtab shiftwidth=4 tabstop=4
        hi StatusLine ctermbg=grey ctermfg=235
    elseif &filetype == 'sh'
        setlocal expandtab shiftwidth=4 tabstop=4
        hi StatusLine ctermbg=grey ctermfg=235
    else
        setlocal expandtab shiftwidth=4 tabstop=4
        hi StatusLine ctermbg=grey ctermfg=235
    endif
endfunction

au BufEnter * call ColourStatusLineFileType()

function! Build()
    filetype detect
    echo "filetype:" &filetype
    let name = expand("%:r")
    if &filetype == 'tex'
        execute :w!<CR>
        execute :!pdflatex %<CR>
    elseif &filetype == 'c'
        execute "! gcc % -o" name
        let res =
        execute "! ./".name
    elseif &filetype == 'sh'
        execute "! chmod +x %"
        execute "! ./%"
    elseif &filetype == 'ruby'
        execute "! chmod +x %"
        execute "! ruby %"
    elseif &filetype == 'python'
        execute "! chmod +x %"
        execute "! python3 %"
    elseif &filetype == 'java'
        execute "! javac %"
        execute "! java" name
    else
        echo "No sabemos como procesar este tipo de archivo"
    endif
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vimdiff
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Ignore whitespace in vimdiff.
if &diff
  set diffopt+=iwhite
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Vimgrep
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"TODO


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Tags
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"T para ir a tag
map T <C-]>

"<C-t> para volver del tag
