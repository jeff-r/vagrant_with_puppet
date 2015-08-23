set nocompatible                            " not compatible with vi

filetype off                                " disable system ftdetect files
call pathogen#runtime_append_all_bundles()  " initialize Pathogen
syntax on                                   " enable syntax highlighting
filetype plugin indent on                   " enable file type detection

set expandtab                               " expand tabs to spaces
set tabstop=2 softtabstop=2                 " number of spaces inserted for a tab
set shiftwidth=2                            " number of spaces inserted per level of indent
set incsearch                               " incremental searching
set cursorline                              " highlight screen line of the cursor
set scrolloff=3                             " always show 3 lines above/below cursor line
set nonumber                                  " display line numbers
set showmatch                               " briefly displays matching bracket
set wildmode=longest,list                   " shell-like file completion
set wildignore=sharedfs/*                   " filter sharedfs out of command-t
set splitbelow                              " new splits open below
set splitright                              " new vsplits open to the right
set backspace=indent,eol,start              " intuitive backspacing
set ignorecase                              " case-insensitive searching
set smartcase                               " case-sensitive if expression contains capital
set title                                   " set the terminal's title
set visualbell                              " no beeping
set directory=/tmp                          " keep swap files in one location
set textwidth=0                             " disable automatic line breaking
set nosmartindent                           " disable smart indenting
set wrap                                    " wrap long lines

set laststatus=2                            " always show statusline
set statusline=
set statusline+=%<\                         " cut at start
set statusline+=%2*[%n%H%M%R%W]%*\          " buffer number, and flags
set statusline+=%-40f\                      " relative path
set statusline+=%=                          " seperate between right- and left-aligned
set statusline+=%1*%y%*%*\                  " file type
set statusline+=%10(L(%l/%L)%)\             " line
set statusline+=%2(C(%v/125)%)\             " column
set statusline+=%P

set background=dark
colorscheme railscasts

" vim helpers
map ,m :set number!<CR>
map ,p :set paste!<CR>

augroup myvimrchooks
  au!
  autocmd bufwritepost .vimrc,.vimrc.local source ~/.vimrc
augroup END

set undofile
set undodir=~/tmp,/tmp
set backupdir=~/tmp,/tmp

" rspec integration
map ,t :call RunSpecFile()<CR>
map ,s :call RunNearestSpec()<CR>
map ,l :call RunLastSpec()<CR>

" configure ack
let g:AckAllFiles = 0
let g:AckCmd = 'ack --type-add ruby=.feature --ignore-dir=tmp 2> /dev/null'
map <LocalLeader>aw :Ack '<C-R><C-W>'

" hash rocket
imap <C-L> <SPACE>=><SPACE>

" command-t
map <silent> <LocalLeader>t  :CommandT<CR>

" retag
map <silent> <LocalLeader>rt :!ctags -R --exclude=".git\|.svn\|log\|tmp\|db\|pkg" --extra=+f<CR>

" NERD Tree
map <silent> <LocalLeader>nt :NERDTreeToggle<CR>
map <silent> <LocalLeader>nr :NERDTree<CR>
map <silent> <LocalLeader>nf :NERDTreeFind<CR>
map <F3> :NERDTreeToggle<CR>

" switch windows
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
map <C-h> <C-w>h

" clear search highlight
map <silent> <LocalLeader>nh :nohls<CR>
map <silent> <LocalLeader>\ :nohls<CR>

" comment/uncomment
map <silent> <LocalLeader>cc :TComment<CR>
map <silent> <LocalLeader>uc :TComment<CR>

" check ruby syntax
map <silent> <LocalLeader>rs :!ruby -c %<CR>

" highlight trailing whitespace
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd BufRead,InsertLeave * match ExtraWhitespace /\s\+$/
" Set up highlight group & retain through colorscheme changes
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
map <silent> <LocalLeader>ws :highlight clear ExtraWhitespace<CR>

" tab autocomplete or indent depending on context
function! InsertTabWrapper()
 let col = col('.') - 1
 if !col || getline('.')[col - 1] !~ '\k'
   return "\<tab>"
 else
   return "\<c-p>"
 endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

" spec support
function! RunSpecFile()
  if InSpecFile()
    let t:last_spec_file_command = "rspec " . @% . " -c "
  endif

  call RunLastSpecFile()
endfunction

function! RunNearestSpec()
  if InSpecFile()
    let t:last_nearest_spec_command = "rspec " . @% . ":" . line(".") . " -c "
  endif

  call RunLastNearestSpec()
endfunction

function! RunLastSpec()
  call RunSpecs()
endfunction

function! InSpecFile()
  return match(expand("%"), "_spec.rb$") != -1
endfunction

function! RunLastNearestSpec()
  if exists("t:last_nearest_spec_command")
    call SetLastSpecCommand(t:last_nearest_spec_command)
    call RunSpecs()
  endif
endfunction

function! RunLastSpecFile()
  if exists("t:last_spec_file_command")
    call SetLastSpecCommand(t:last_spec_file_command)
    call RunSpecs()
  endif
endfunction

function! RunSpecs()
  if exists("t:last_spec_command")
    execute ":w\|!clear && echo " . t:last_spec_command . " && echo && " . t:last_spec_command
  endif
endfunction

function! SetLastSpecCommand(command)
  let t:last_spec_command = a:command
endfunction


" Jeff's changes

" Folding for Ruby
"
" ,z  -- Show only last search
" ,zz -- Show only "describe ..." and "it ..." lines in specs
" ,zd -- Show only "class ..." and "def ..." lines in Ruby files
" zR  -- Remove all folds
"
" From http://vim.wikia.com/wiki/Folding_with_Regular_Expression
nnoremap ,z :setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2 foldmethod=expr foldlevel=0 foldcolumn=2<CR>

" Then variations on that, with different searches ...
"
" Fold spec files, displaying "describe ..." and "it ..." lines
function! FoldSpec()
  let @/='\(describe.*do$\|it.*do$\)'
  setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2 foldmethod=expr foldlevel=0 foldcolumn=2
endfunction
map ,zz :call FoldSpec()<CR>

" Fold Ruby, showing class and method definitions
function! FoldDefs()
  let @/='\(module\ \|class\ \|has_many\ \|belongs_to\ \|_filter\ \|helper\ \|belongs_to\ \|def\ \|private\|protected\)'
  setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2 foldmethod=expr foldlevel=0 foldcolumn=2
endfunction
map ,zd :call FoldDefs()<CR>

" Set the text that represents folded lines to a simple dash, showing no
" information.
" This way, when viewing folded specs and classes, there is minimal cruft on
" the screen to distract from the unfolded content.
set foldtext=MyFoldText()
function! MyFoldText()
  return "-"
endfunction

set t_Co=256color

nmap ; :
nmap ,1 :!git show <c-r><c-w><cr>
nmap ,b :!git branch --contains <c-r><c-w><cr>
nmap ,c :Ag <c-r><c-w> spec/ <cr>
nmap ,g :!git l --grep <c-r><c-w><cr>
nmap ,o :!open https://www.pivotaltracker.com/story/show/<c-r><c-w><cr>
nmap ,<space> :% s/\s*$// <cr>
nmap ,r :source ~/.vimrc <cr>
nmap ,rp Orequire "pry"<cr>binding.pry<esc>
nmap ,e :E<cr>
nmap <left>  :cp<cr>
nmap <right> :cn<cr> 
nmap ,2 o<esc>k :r ! ./get_story_from_commit  <c-r><c-w><esc> kddpkJ <cr>dd
nmap Y y$
nmap ,vp :execute "rightbelow vsplit " . bufname("#")<cr>

" For StreamSend qa tests
" interpret the word under the cursor as referring to a page object,
" and then edit the file containing that page object.
function! PathForPageObjectUnderCursor()
  let page_name = expand("<cword>")
  let len = strlen(page_name)
  let page_name = strpart(page_name,0,len-5)
  let page_file_name = "spec/support/pages/" . strpart(page_name,0,len-5) . ".rb"
  return page_file_name
endfunction
function! SplitToPageObjectUnderCursor()
  :exe ":vsp " . PathForPageObjectUnderCursor()
endfunction
function! GoToPageObjectUnderCursor()
  :exe ":e " . PathForPageObjectUnderCursor()
endfunction
nmap ,a :call GoToPageObjectUnderCursor()<cr>
nmap ,av :call SplitToPageObjectUnderCursor()<cr>

map ,gp :e spec/support/pages/ <cr>
  
augroup myvimrchooks
  au!
  autocmd bufwritepost .vimrc,.vimrc.local source ~/.vimrc
augroup END

set undofile
set undodir=~/tmp,/tmp
set backupdir=~/tmp,/tmp 

au BufNewFile,BufRead *.handlebars set filetype=html
