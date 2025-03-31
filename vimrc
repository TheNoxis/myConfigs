" -----------------------------------------------
" CONFIGURATION PERSONNEL
" -----------------------------------------------
" DESC: syntax highlighting
if has("syntax")
	syntax on
endif
" -----------------------------------------------
" DESC: FIXME
let mapleader = "²"
" -----------------------------------------------
" DESC: Show (partial) command in status line.
"set showcmd
" -----------------------------------------------
" DESC: Show matching brackets.
set showmatch
" -----------------------------------------------
" DESC: Do case insensitive matching
"set ignorecase
" -----------------------------------------------
" DESC: Do smart case matching
"set smartcase
" -----------------------------------------------
" DESC: Search hilighting
set hlsearch
" -----------------------------------------------
" DESC: Incremental search
"set incsearch
" -----------------------------------------------
" DESC: Automatically save before commands like :next and :make
"set autowrite
" -----------------------------------------------
" DESC: Hide buffers when they are abandoned
"set hidden
" -----------------------------------------------
" DESC: Enable mouse usage (all modes)
" IMPOSSIE DE FAIRE UN CLICK DROIT AVEC
"mouse=a
" -----------------------------------------------
" DESC: To insert space characters whenever the tab key is pressed
"set expandtab
" -----------------------------------------------
" DESC: use 4 spaces to represent tab when expandtab enable
set tabstop=4
" -----------------------------------------------
set softtabstop=4
" -----------------------------------------------
" DESC: break lines when line length increases
"set textwidth=120
" -----------------------------------------------
" DESC: Number of spaces to use for auto indent
set shiftwidth=4
" -----------------------------------------------
" DESC: copy indent from current line when starting a new line
set autoindent
" -----------------------------------------------
" DESC: backspace over everything in insert mode
"       make backspaces more powerfull
set backspace=indent,eol,start
" -----------------------------------------------
" DESC: show line and column number
"set ruler
" -----------------------------------------------
" DESC: show (partial) command in status line
"set showcmd
" -----------------------------------------------
" DESC: FIXME
"set sm
" -----------------------------------------------
" DESC: Charset
set encoding=utf-8 nobomb
set fileencoding=utf-8
" -----------------------------------------------
" DESC: FIXME
set laststatus=2
" -----------------------------------------------
" DESC: First thing is entering vim mode, not plain vi
set nocompatible
" -----------------------------------------------
" DESC: Force 256 colors on the terminal
set t_Co=256

" -----------------------------------------------
" DESC: load the color scheme before anything
colorscheme noxis

" -----------------------------------------------
" DESC: Current line (Horizontal):
set cursorline

" -----------------------------------------------
" DESC: Current line (Vertical):
set cursorcolumn

" -----------------------------------------------
" DESC: Affiche les numero de ligne
set number

" -----------------------------------------------
" DESC: Nombre maximal de carractère sur une ligne:
set colorcolumn=105
"match ErrorMsg '\%>105v.\+'

" -----------------------------------------------
" DESC: Copy/past buffer:
"       Connaitre sa valeur: :verbose set viminfo?
"       Exemple output: viminfo='100,<50,s10,h
set viminfo='50,<1000,s100,h

" -----------------------------------------------
" DESC: dictionnaire
"       http://www.vim.org/scripts/script.php?script_id=465
"set dictionary=/usr/share/dict/words

" -----------------------------------------------
" DESC: folding function/code
set foldmethod=indent	" Basé sur l'indentation
set foldnestmax=5		" Nb de fold max en recurcif
set foldminlines=2		" Nombre de ligne min pour pouvoir etre clos
set foldlevel=10		" Niveau min du fold ouvert au lancement
"let g:sh_fold_enabled=7

" -----------------------------------------------
" DESC: Gestion de template
"       http://vim.wikia.com/wiki/Use_eval_to_create_dynamic_templates
augroup templates
	au!
	" read in template files
	autocmd BufNewFile *.*      silent! execute '0r $HOME/.vim/templates/skeleton.'.expand("<afile>:e")
	autocmd BufNewFile Makefile silent! execute '0r $HOME/.vim/templates/Makefile.tpl'
	autocmd BufNewFile Dockerfile silent! execute '0r $HOME/.vim/templates/Dockerfile.tpl'
	" parse special text in the templates after the read
	autocmd BufNewFile * %substitute#\[:VIM_EVAL:\]\(.\{-\}\)\[:END_EVAL:\]#\=eval(submatch(1))#ge
augroup END


" -----------------------------------------------
" http://vim.wikia.com/wiki/Make_views_automatic
let &viewdir=expand("$HOME") . "/.vim_viewdir"
if !isdirectory(expand(&viewdir))|call mkdir(expand(&viewdir), "p", 451)|endif
"autocmd BufWinLeave * mkview
"autocmd BufWinEnter * silent loadview
" Test:
" autocmd BufWrite * mkview
 "autocmd BufNewFile,BufRead * silent loadview


" -----------------------------------------------
" DESC: Show table
set list

" -----------------------------------------------
" DESC: Carractères de substitution
" tab: tabulation
" trail: espace en fin de ligne
" space: espace en général
set lcs=tab:\►\ ,trail:·
" http://www.fileformat.info/info/unicode/char/b7/browsertest.htm
" set listchars+=space:·



" -----------------------------------------------
" Module: pathogen
" Chargement des modules cloné par git dans bundle:
execute pathogen#infect()

" -----------------------------------------------
" Module: Neocomplete
let g:neocomplete#enable_at_startup = 0
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 2

" -----------------------------------------------
" Module: Neocomplcache
" let g:neocomplcache_enable_at_startup = 1

" -----------------------------------------------
" Module: ACP (AutoComplPop)
let g:neocomplete#enable_auto_select = 1
autocmd FileType python		set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html		set omnifunc=htmlcomplete#CompleteTags
autocmd FileType markdown	set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css		set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml		set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php		set omnifunc=phpcomplete#CompletePHP
autocmd FileType c			set omnifunc=ccomplete#Complete

" -----------------------------------------------
" DESC: Configure expanding of tabs for various file types
autocmd FileType python set noexpandtab ts=4 sw=4
autocmd FileType yaml   set ts=2 sts=2 sw=2 expandtab indentkeys-=<:>
autocmd BufRead,BufNewFile *.h       set noexpandtab
autocmd BufRead,BufNewFile Makefile* set noexpandtab
" Dans un .c une selection suivis de 'gq' indentera automatiquement la portion de code:
autocmd BufRead,BufNewFile *.c       set noexpandtab formatprg=indent\ -kr\ -ts4
autocmd BufRead,BufNewFile /etc/php5/fpm/* set syntax=dosini
autocmd BufRead,BufNewFile .offlineimaprc  set syntax=dosini
autocmd BufRead,BufNewFile k3s.conf  set syntax=yaml


" -----------------------------------------------
" Module: vim-gradle (highlighting) src: https://github.com/tfnico/vim-gradle/tree/master/ftdetect

" -----------------------------------------------
" Module: neosnippet
" imap <C-k>     <Plug>(neosnippet_expand_or_jump)
" smap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1
"
" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.vim/bundle-available/vim-neosnippet-snippets/neosnippets'

" -----------------------------------------------
" Module: vim-airline
" :help airline
" Smarter tab line
" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#left_sep = ' '
" let g:airline#extensions#tabline#left_alt_sep = '|'
" -- Séparateur
" let g:airline_left_sep='▶'
" let g:airline_right_sep='◀'
let g:airline_left_sep=''
let g:airline_right_sep=''
" -- Autres
" let g:airline_symbols.crypt='🔒'
" let g:airline_symbols.linenr='¶'
" let g:airline_symbols.branch=''
" let g:airline_symbols.paste = 'ρ'
" let g:airline_symbols.whitespace='Ξ'

" -----------------------------------------------
" Module: delimiter
" src: https://github.com/Raimondi/delimitMate.git
"let loaded_delimitMate = 1
"let delimitMate_expand_cr = 1
"let delimitMate_expand_space = 1
"let delimitMate_autoclose = 0
"let delimitMate_smart_quotes = '\w\%#'

" -----------------------------------------------
" Module: auto-pairs
" src: https://github.com/jiangmiao/auto-pairs/blob/master/doc/AutoPairs.txt
let g:AutoPairsFlyMode = 0
"let AutoPairs['<'] = '>'
au Filetype html let b:AutoPairs = {"<": ">"}

" -----------------------------------------------
" DESC: Vim load indentation rules and plugins
"       according to the detected filetype.
"if has("autocmd")
"  filetype plugin indent on
"endif

" -----------------------------------------------
" DESC: Vim jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif



" -----------------------------------------------
" --- TAB AUTOCOMPLETE --------------------------
" http://vim.wikia.com/wiki/Smart_mapping_for_tab_completion
function! Smart_TabComplete()
  let line = getline('.')                         " current line

  let substr = strpart(line, -1, col('.')+1)      " from the start of the current
                                                  " line to one character right
                                                  " of the cursor
  let substr = matchstr(substr, "[^ \t]*$")       " word till cursor
  if (strlen(substr)==0)                          " nothing to match on empty string
    return "\<tab>"
  endif
  let has_period = match(substr, '\.') != -1      " position of period, if any
  let has_slash = match(substr, '\/') != -1       " position of slash, if any
  if (!has_period && !has_slash)
    return "\<C-X>\<C-P>"                         " existing text matching
  elseif ( has_slash )
    return "\<C-X>\<C-F>"                         " file matching
  else
    return "\<C-X>\<C-O>"                         " plugin matching
  endif
endfunction
" inoremap <tab> <c-r>=Smart_TabComplete()<CR>


" Intelligent tab completion
function! <SID>InsertTabWrapper(direction)
  let idx = col('.') - 1
  let str = getline('.')
  if a:direction > 0 && idx >= 2 && str[idx - 1] == ' '
        \&& str[idx - 2] =~? '[a-z]'
    if &softtabstop && idx % &softtabstop == 0
      return "\<BS>\<Tab>\<Tab>"
    else
      return "\<BS>\<Tab>"
    endif
  elseif idx == 0 || str[idx - 1] !~? '[a-z]'
    return "\<Tab>"
  elseif a:direction > 0
    return "\<C-p>"
  else
    return "\<C-n>"
  endif
endfunction
" inoremap <silent> <Tab> <C-r>=<SID>InsertTabWrapper(1)<CR>
" inoremap <silent> <S-Tab> <C-r>=<SID>InsertTabWrapper(-1)<CR>


function! Tab_Or_Complete()
  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
    return "\<C-N>"
  else
    return "\<Tab>"
  endif
endfunction
inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>


" -----------------------------------------------
" Module: Syntastic
" Pour python: apt install python-flake8
" Pour html: apt install tidy
" Pour bash: apt install shellcheck
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
"set statusline+=%**/
" To setup Syntastic to automatically load errors into the location list:
let g:syntastic_always_populate_loc_list = 0
"
let g:syntastic_auto_loc_list = 0
" By default, Syntastic does not check for errors when a file is loaded into Vim:
let g:syntastic_check_on_open = 0
" By default, Syntastic checks for errors whenever you save the file.
let g:syntastic_check_on_wq = 0
"
let g:syntastic_enable_signs=1
"
let g:syntastic_error_symbol = "✗"
let g:syntastic_warning_symbol = "⚠"
" To disable warnings use:
" let g:syntastic_quiet_messages={'level':'warnings'}
"
let g:syntastic_php_checkers = ['php', 'phpcs', 'phpmd']
"
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': [] }
"
let g:syntastic_python_checkers = ['flake8']
"
let g:syntastic_python_flake8_args = "--max-line-length=105"
"
let g:syntastic_aggregate_errors = 1
"
" nnoremap <C-l> :SyntasticCheck<CR> :SyntasticToggleMode<CR>
" vnoremap <C-l> :SyntasticCheck<CR> :SyntasticToggleMode<CR>
nnoremap <C-c> :SyntasticCheck<CR>
vnoremap <C-c> :SyntasticCheck<CR>


" -----------------------------------------------
" Module: Tagbar
nmap <F8> :TagbarToggle<CR>


" -----------------------------------------------
" Module: NERDcomment
filetype plugin on
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1
" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = {
	\ 'c': { 'left': '/**','right': '*/' },
	\ 'haproxy': { 'left': '#' }
\ }
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
"
let g:NERDCreateDefaultMappings = 0
"
nnoremap <C-q> :call nerdcommenter#Comment(0,"toggle")<CR>
vnoremap <C-q> :call nerdcommenter#Comment(0,"toggle")<CR>
inoremap <C-q> <C-O>:call nerdcommenter#Comment(0,"toggle")<CR>


" -----------------------------------------------
" Module: cTags
let Tlist_Ctags_Cmd = '/usr/bin/ctags'
nnoremap <silent> <F9> :TlistToggle<CR>


" -----------------------------------------------
" --- KEY BINDING -------------------------------
" http://www.cyberciti.biz/faq/vim-vi-text-editor-save-file-without-root-permission/
command W :execute ':silent w !sudo tee % > /dev/null' | :edit!
" En mode visual tab et shift+tab indente le code:
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv
" --
map <C-t> :normal za<CR>
" Toggle numero et ligne Touche [MAJ]+[H]
nnoremap H :set nu! cursorline! cursorcolumn! list! paste!<CR> :startinsert<CR>
" -- Execute le script en editer, avec [ctrl]+[p]
map <C-p> :!clear; ./%<CR>
" --


" -- DEPLACEMNT DU CURSOR ----------
" (ALT+Arrow) Putty + tmux + zsh
" map "^[[1;3C" <M-Left>
" map "^[[1;3D" <M-Right>

" (CTRL+Arrow) Putty + zsh
" map [D <C-Right>
" map [C <C-Left>

" (CTRL+Arrow) Putty + tmux + zsh:
" map ^[^[[C <M-left>
" map ^[[D <M-Right>

" ------
" f: Saute le curseur d'un mot en avant:
" b: Saute le curseur d'un mot en arriere:

" CTRL+Arrow:
" nnoremap <C-Left> w
" nnoremap <C-Right> b

" ALT+Arrow:
" nnoremap <M-Right> w
" nnoremap <M-left> b


" ctr+w pour supprimer le mot avant le curseur:
"inoremap <c-w> <c-o>dB
" Quit et demande de sauvegarde si besoin
" map <C-w> :confirm quit<CR>
"
" map <C-w> <CR>*/

" map "^[[1;5C" <M-Left>
" map "^[[1;5D" <M-Right>

