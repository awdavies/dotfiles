let mapleader=","
set ts=2
set sw=2
set expandtab
set spl=en
set wrap
set ai
set backupdir=~/.vim/tmp
set directory=~/.vim/tmp

" Pathogen!
execute pathogen#infect()

syntax on
filetype plugin indent on
imap jk <esc>

" Line number toggling.
function! NumberToggle()
  if (&relativenumber == 1)
    set number
  else
    set relativenumber
  endif
endfunc
nnoremap <C-n> :call NumberToggle()<cr>
:au BufRead /tmp/mutt-* set tw=72
:au BufRead /home/andrew/documents/junk/story/* set tw=72
:au FocusLost * :set number
:au FocusGained * :set relativenumber
" map <leader>b :CtrlPBufferautocmd InsertLeave * :set relativenumber
autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber

" CTRL P Commands!
map <leader>b :CtrlPBuffer<enter>

" Tag list!
map <leader>t :TlistToggle<enter>

" General commands.
map <leader>l :lnext<enter>
map <leader>h :lprev<enter>

" Eclim commands that don't suck!
imap <C-Space> <C-x><C-u>
imap <C-@> <C-Space>
map <C-o> :JavaDocPreview<enter>
map <C-i> :pc<enter>
map <leader>s :ProjectSettings<enter>
map <leader>m :ProjectBuild<enter>
map <leader>e :ProjectProblems<enter>

" If you prefer the Omni-Completion tip window to close when a selection is
" made, these lines close it on movement in insert mode or when leaving
" insert mode
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" Eclim autocomplete for Java!
let g:acp_behaviorJavaEclimLength = 3
function MeetsForJavaEclim(context)
  return g:acp_behaviorJavaEclimLength >= 0 &&
        \ a:context =~ '\k\.\k\{' . g:acp_behaviorJavaEclimLength . ',}$'
endfunction
let g:acp_behavior = {
      \ 'java': [{
      \ 'command': "\<c-x>\<c-u>",
      \ 'completefunc' : 'eclim#java#complete#CodeComplete',
      \ 'meets'        : 'MeetsForJavaEclim',
      \ }]
      \ }

set relativenumber
set background=dark
colorscheme solarized

" Map space to center window.
map <space> zz

" Window switching.
map <leader>w <C-w>w

" Set up relative line numbers in NERDTree.
function NERDToggle()
  :NERDTreeToggle
  if (exists("b:NERDTreeType") && b:NERDTreeType == "primary")
    :call NumberToggle()
  endif
endfunction

" NERDTree Commands.
map <leader>a :call NERDToggle()<CR>
