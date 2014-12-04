" Pathogen!
execute pathogen#infect()

let mapleader=","
set sw=2
set ts=2
set expandtab
set spl=en
set wrap
set ai
set backupdir=~/.vim/tmp
set directory=~/.vim/tmp
set t_Co=256
set colorcolumn=80

" Some more necessary junk.
syntax on
set relativenumber
filetype plugin indent on
"hi Normal ctermfg=16 ctermbg=254

" Line number toggling.
function! NumberToggle()
  if (&relativenumber == 1)
    set number
  else
    set relativenumber
  endif
endfunc
nnoremap <C-n> :call NumberToggle()<cr>

" A few mutt settings.
:au BufRead /tmp/mutt-* set tw=72
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
imap jk <esc>

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

" Colorscheme Setup.
set background=dark
colorscheme twilight

" Map space to center window.
map <space> zz

" Set up relative line numbers in NERDTree.
function NERDToggle()
  :NERDTreeToggle
  if (exists("b:NERDTreeType") && b:NERDTreeType == "primary")
    :call NumberToggle()
  endif
endfunction

" NERDTree Commands.
map <leader>a :call NERDToggle()<CR>
:let g:session_autosave = 'no'

function ClearTrailing()
  :mark x  " Use a mark I would never use.
  :%s/\s\+$//e
  :'x   " recall said mark.
  :delmark x
endfunction

" This silly function has to do with changing the colorscheme for Indent
" Editing.  This stuff won't update unless we force it to after changing
" the colorscheme.
function WhiteSpaceHandler()
  " Indent guides (man's best friend).
  "let g:indent_guides_color_change_percent = 30
  "let g:indent_guides_guide_size = 1
  let g:indent_guides_auto_colors = 0
  hi IndentGuidesOdd  ctermbg=242
  hi IndentGuidesEven ctermbg=238
  " Display trailing whitespace.
  hi ExtraWhitespace ctermbg=242
  autocmd BufWinEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  " Autoremove trailing whitespace.
  autocmd BufWritePre * call ClearTrailing()
endfunction
:call WhiteSpaceHandler()

" Toggles between tab editing and space editing.
function TabToggle()
  if &expandtab
    set shiftwidth=2
    set softtabstop=0
    set noexpandtab
    set background=dark
    colorscheme twilight
    :call WhiteSpaceHandler()
  else
    set shiftwidth=2
    set softtabstop=2
    set expandtab
    set background=dark
    colorscheme base16-default
    :call WhiteSpaceHandler()
  endif
endfunction
map <leader><space> :call TabToggle()<CR>

" Force jinja highlighting.
au BufNewFile,BufRead *.html,*.htm,*.shtml,*.stm set ft=jinja

" Display tabs visually.
set listchars=tab:».
set list
