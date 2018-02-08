"~/.vimrc -- VI configuration file

" Set HOME if not running Cygwin's VIM
if !has("win32unix")
    if !empty($USERPROFILE)
        let $HOME=expand("$USERPROFILE")
    endif
endif

" Set the font to use for the gui window on Linux
"set guifont=-adobe-courier-medium-r-normal-*-*-120-*-*-m-*-iso10646-1
"set guifont=Courier\ 9
"set guifont=Monospace\ 7
" dw 10/14/2009 -- guifont for MacOS X 10.6
"set guifont=DejaVu\ Sans\ Mono:h10.00
set guifont=Consolas:h10

if has("gui_running")
    "winpos 1600 0
    set columns=140
    set lines=63
    set guioptions-=T  " Disable toolbar
    set guioptions-=m  " Disable menu
    "set guioptions-=r  " Disable right-hand scrollbar
    set guicursor+=i-r:ver100-iCursor
    set guicursor+=a-c-i-r-n-v:blinkon0
endif

" Set backup directory for '~' & '.swp' files
set backupdir=~/tmp
set directory=~/tmp

" Turn on syntax highlighting
syntax on

" Turn on file type detection
filetype on

" Enable filetype plugins
filetype plugin on

" Set up the desired colors for syntax highlighting
" Set these following the 'syntax on' command/ 'syntax on' causes VIM to overwrite all
" settings
hi Normal       guibg=#333A3F guifg=#999999
hi Comment      gui=none      guifg=DarkGreen   ctermfg=DarkGreen
hi Constant     gui=none      guifg=FireBrick   ctermfg=DarkRed
hi PreProc      gui=none      guifg=Red         ctermfg=Red         cterm=none
hi Statement    gui=none      guifg=#999999     ctermfg=White       cterm=none  term=none
hi Function     gui=none                        ctermfg=Cyan        cterm=none
hi Identifier   gui=none                        ctermfg=White
hi Tag          gui=bold      guifg=SteelBlue   ctermfg=White
hi Type         gui=bold      guifg=SteelBlue   ctermfg=White       cterm=none term=none
hi Search       gui=bold      guifg=DarkBlue    guibg=Orchid3       ctermfg=LightMagenta  ctermbg=White  cterm=none
hi! link IncSearch Search
hi Special      guifg=SteelBlue                 ctermfg=White
hi SpecialKey   guifg=SteelBlue                 ctermfg=White
hi StatusLine   gui=reverse   guifg=DarkRed     guibg=White         ctermfg=DarkRed       ctermbg=White
hi Visual       gui=none      guifg=Black       guibg=Yellow        ctermfg=Black         ctermbg=yellow  cterm=none
hi MatchParen   term=reverse  ctermbg=6         guibg=Magenta
hi Cursor       guifg=Black   guibg=White
hi iCursor      gui=reverse   guifg=Magenta     guibg=White
hi xmlTag       gui=none                        ctermfg=Cyan        cterm=none
hi xmlTagName   guifg=Cyan                      ctermfg=Cyan        cterm=none
hi xmlTagEnd    gui=none                        ctermfg=Cyan        cterm=none

" Show position within current file at the bottom of the screen
set ruler

" Turn on line numbering for all files
"set number

" Enable backspace past beginning of current insert, line breaks, and autoindent
set backspace=start,eol,indent

" Set the tab key to insert spaces
set expandtab

" Set <BS> to delete one Tab's worth of spaces
set softtabstop=4

" Set tab stops to modulo 4, instead of the default 8, to make the file
" easier to read in a smaller window
set tabstop=4

" Set the shift width (>> & <<) to coordinate with tabstop
set shiftwidth=4

" Set the text width, after which text is automagically wrapped in insert mode
set textwidth=90

" Show the current mode at the bottom of the window
set showmode

" Set the height of the history command window (default is only 7)
set cmdwinheight=20

" Set updatetime to a lower value for use with TagList plugin
set updatetime=1000

" Set autowrite to write any changed buffers prior to executing make
set autowrite

" Disable expandtab (turn off tabs->spaces) for Makefiles
au FileType make setlocal noexpandtab

" Set file type for inline C++ definitions file (*.ipp)
au BufRead,BufNewFile *.ipp set filetype=cpp

" Capital Y should copy from the current cursor position to the end of the current line.
map Y y$

" Capital D should delete from the current cursor position to the end of the current line.
map D d$

" Lowercase t is aliased to  to make jumping to tags a one-handed operation (lazy).
map t g]

" Source this file
map 's :execute("source ~/.vimrc")

" Change window/buffer focus
map 'w 

" Map the <F2> key to list the currently open buffers.
map <F2> :execute("ls")

" Map the <F3> key to execute the 'ctags' function for the current directory.
" This will use the options from the .ctags file in my home directory
map <F3> :execute("!ctags -R -a -f tags")

" Map the <F4> key to have Perforce open the current file for editing.
" This also turns off the read-only attribute of the file since it
" was not read-write when VI opened the file.
"map <F4> :!p4 edit %:set noro

" Map the <F5> key to write the current file to disk.
map <F5> :execute("w")

" Map <F6>, <F7>, & <F8> to cut, copy & paste, respectively.
" Use \"+ (CUT_BUFFER0) rather than \"* (PRIMARY) for X11 compatibility.
" Note that Xterm uses PRIMARY for copy/paste operations.
" See :he x11-selection for more information

" Map the <F6> key to Cut
map <F6> "+x
map <M-F6> "*x

" Map the <F7> key to Copy
map <F7> "+y
map <M-F7> "*y

" Map the <F8> key to Paste
map <F8> "+p
map <S-F8> "+P
map <M-F8> "*p
map <S-M-F8> "*P

" Indent C source code
map <F11> :!indent

" Turn off search highlighting when ESC is hit
" dw 07/14/2006 -- This is causing VIM on Linux to open files in Insert mode.
" This doesn't happen on Windows.  I don't understand why this is ???
""" noremap  :noh  

map <C-N> :execute("e #")

" Map Ctrl+Q to alternate between the last two used buffers, similar
" to the Alt+Tab behavior in Windows
"map <C-Q> :execute("e #")
map <C-Tab> :execute("e #")

" Map Shift+Q to rotate forwards through the list of buffers.
"map <S-Q> :execute("bn")
map <C-S-Tab> :execute("bn")

" Map Ctrl+Shift+Tab to rotate backwards through the list of buffers
"map <C-S-Q> :execute("bp")


" Set C style indenting since I'm probably editing C code
set cindent

" Turn on highlighting for search terms
set hlsearch

" Set search "/xxx" to be incremental (as each char is typed)
set incsearch

" Set suffixes so vi will ignore certain files
set suffixes=.bak,~,.o,.obj,.swp,.vq,.class

" Turn on the status line always
set laststatus=2

" Show a two line command window at the bottom of the vi/vim/gvim session
set cmdheight=2

" Turn off the bell
set noerrorbells 
set visualbell
set t_ti= t_te= t_vb=

" Set default clipboard to the Windows clipboard
set clipboard=unnamed


" Show syntax group for word under cursor
" See - https://stackoverflow.com/questions/9464844/how-to-get-group-name-of-highlighting-under-cursor-in-vim
function! SynGroup()                                                            
    let l:s = synID(line('.'), col('.'), 1)                                       
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun

