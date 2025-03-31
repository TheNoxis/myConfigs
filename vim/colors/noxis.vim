" Theme: noxis
" Version: 0.1
" Maintainer: Noxis <shenry.perso@gmail.com>
"
" Copyright (c) 2015, Noxis
" All rights reserved.
"
" Redistribution and use in source and binary forms, with or without
" modification, are permitted provided that the following conditions are met:
"
" * Redistributions of source code must retain the above copyright notice, this
"   list of conditions and the following disclaimer.
"
" * Redistributions in binary form must reproduce the above copyright notice,
"   this list of conditions and the following disclaimer in the documentation
"   and/or other materials provided with the distribution.
"
" THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
" IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
" DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
" FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
" DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
" SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
" CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
" OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
" OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

" ================================================================

" Aide pour les couleurs:
" http://www.calmar.ws/vim/256-xterm-24bit-rgb-color-chart.html

" Reset des highlight:
highlight clear
" Arriere plan sombre
set background=dark
"
if exists("syntax_on")
    syntax reset
endif
"
let g:colors_name="noxis"
" -----------------------------------------------
highlight Normal      ctermfg=white  ctermbg=black
" -----------------------------------------------
" Comment       Comments within a program
highlight Comment      ctermfg=240  ctermbg=NONE  cterm=NONE
" -----------------------------------------------
" Constant      Program constants, such as numbers, quoted strings, or true/false
highlight Constant     ctermfg=063
" -----------------------------------------------
" Identifier    Variable identifier names
highlight Identifier   ctermfg=75
" -----------------------------------------------
" String        Quoted strings, ex: "wath else"
highlight String       ctermfg=060
" -----------------------------------------------
" Statement     A programming language statement, usually a keyword like "if" or "while"
highlight Statement    ctermfg=10
" -----------------------------------------------
" PreProc       A preprocessor, such as "#include" in C
highlight PreProc      ctermfg=11
" -----------------------------------------------
" Type          A variable datatype, such as "int"
highlight Type         ctermfg=162
" -----------------------------------------------
" Special       A special symbol, usually used for special characters like "\n" in strings
highlight Special      ctermfg=2
" -----------------------------------------------
" Underlined    Text that should be underlined
" -----------------------------------------------
" Function      Function name
highlight Function     ctermfg=069
" -----------------------------------------------
" Pmenu         Popup menu, autocompletion
highlight Pmenu        ctermfg=black  ctermbg=240
highlight PmenuSel     ctermfg=White  ctermbg=DarkGreen
" -----------------------------------------------
" Error         Text which contains a programming language error
highlight Error        ctermfg=160  ctermbg=1
" -----------------------------------------------
" Search        Show result of search
highlight Search       ctermfg=black  ctermbg=Yellow
" -----------------------------------------------
" Todo          Exemple: FIXME TODO XXX
highlight Todo         ctermfg=white  ctermbg=red
" -----------------------------------------------
" Tabulation    Tab
highlight SpecialKey   ctermfg=236  ctermbg=NONE
" -----------------------------------------------
" Fold          Toggled bloc code
highlight Folded       ctermbg=green      ctermfg=blue
highlight FoldColumn   ctermbg=darkgreen  ctermfg=white
" -----------------------------------------------
" Visual        Selection multiligne
highlight Visual       ctermfg=black  ctermbg=250
" -----------------------------------------------
" StatusLine    Bottom line with status/information
" highlight StatusLine  ctermbg=red
" highlight StatusLineNC
" -----------------------------------------------
" VertSplit     vertical windows split (use :vsplit)
highlight VertSplit    ctermfg=black  ctermbg=red
" -----------------------------------------------
" NonText       None editable area
highlight NonText      ctermbg=52
" -----------------------------------------------
highlight ExtraWhitespace ctermbg=NONE  ctermfg=red
match ExtraWhitespace /\s\+$\| \+\ze\t/
" -----------------------------------------------
" LineNr       Vertical bare with line number
highlight LineNr       ctermfg=Gray  ctermbg=233  cterm=NONE
" -----------------------------------------------
" CursorLineNr Cursor position in the vertical bare (:hover)
highlight CursorLineNr ctermfg=white  ctermbg=DarkGreen
" -----------------------------------------------
" CursorLine   Axe horizontal for the cursor position
highlight CursorLine   term=NONE  cterm=NONE  ctermfg=NONE  ctermbg=234
" -----------------------------------------------
" CursorColumn Axe vertical for the cursor position
highlight CursorColumn term=NONE  cterm=NONE  ctermfg=NONE  ctermbg=NONE
" -----------------------------------------------
" ColorColumn -- Vertical line for limit max line size:
highlight ColorColumn ctermbg=233
