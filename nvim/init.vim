" Plugins {{{

" Plug {{{
call plug#begin()
Plug 'wonkodv/zem'
Plug 'junegunn/vim-easy-align'
Plug 'neovim/nvim-lsp'
Plug 'neovim/nvim-lspconfig'
Plug 'rust-lang/rust.vim'
Plug 'ishan9299/nvim-solarized-lua'
Plug 'tpope/vim-fugitive'
Plug 'kaarmu/typst.vim'
call plug#end()

" }}}

" Interpreters {{{ 
if has('win32') || has('win64')
    let g:python3_host_prog = 'c:/Windows/py.exe'
endif

let g:no_plugin_maps = 1 " no key mappings from file types

let g:loaded_perl_provider   = 1
let g:loaded_node_provider   = 1
let g:loaded_ruby_provider   = 1
let g:loaded_python_provider = 1

" }}}


" ZEM {{{
let  g:zem_db      =  '.index'
let  g:zem_height   =  30
let  g:zem_sources = [
    \   ['files', {}],
    \   ['tags', {"file": "!ctags --c-kinds=+px --python-kinds=-i -o - --recurse --sort=no --exclude=target"}]
    \   ]
" }}}

" }}} Plugins

" {{{ FileTypes, Syntax
"
syntax enable
filetype plugin indent on

let g:tex_flavor = "latex"
let g:markdown_folding = 1

augroup myautocommands
    autocmd!
    au BufReadPost,BufNewFile *.tags                    setlocal filetype=tags
    au BufReadPost,BufNewFile .tags.*                   setlocal filetype=tags
    au BufReadPost,BufNewFile *.lds                     setlocal filetype=ld
    au BufReadPost,BufNewFile *.md                      setlocal filetype=markdown
    au BufReadPost,BufNewFile *.icf                     setlocal filetype=iarlinker
    au BufReadPost,BufNewFile *.mk                      setlocal filetype=make
    au BufReadPost,BufNewFile */.git/*                  setlocal bufhidden=wipe
    autocmd FileType      gitcommit,gitrebase,gitconfig setlocal bufhidden=delete
    au QuickFixCmdPost    *                             setlocal cmdheight=2 | call QFSigns()
    au TermOpen           *                             setlocal statusline=TERM:%{b:term_title}
    au FileType           qf                            setlocal wrap
    au BufWritePost       *                             call AutoChmod(expand("<afile>"))
    autocmd BufReadPost   *                             lcd .  " update window title relative paths
    " autocmd BufReadPost   *                             call JumpToLastEdit()

augroup END

" }}}

" Colors, Highlighting {{{
set background=light
set termguicolors
lua vim.g.solarized_visibility = 'normal'
lua vim.g.solarized_italics = 0

colorscheme solarized

highlight clear SpellBad
highlight clear SpellCap
highlight clear SpellRare
highlight clear SpellLocal
highlight link markdownError NONE


highlight MatchParen gui=bold guifg=red

highlight Match guibg=#c4c4c4 guifg=#000066

highlight link LspReferenceText Match
highlight link LspReferenceRead Match
highlight link LspReferenceWrite Match

" }}}

" Settings {{{
"
"pip install neovim neovim-remote
let $EDITOR="nvr --remote-tab-wait"
" let $PAGER="cat"

set backupdir-=.

set backspace=eol,indent,start
set backup
set breakindent
set cedit=<C-F>
set cinkeys=0{,0},0),:,0#,!^F,o,O,e
set cinoptions=L0,l1,b1,t0,(0,#0
set clipboard=unnamedplus
set complete=.,w,b,u,t
set completeopt=menuone,noselect ",longest ",preview
set completefunc=ZemComplete
set cursorcolumn
set cursorline
set diffopt=filler,internal,context:4,algorithm:minimal,hiddenoff,indent-heuristic,linematch:60
set display=lastline,uhex
set expandtab
set exrc
set fileformats=unix,dos
set fixendofline
set foldenable
set foldlevelstart=99
set foldmethod=indent " syntax can be really expensive on large files
set foldopen=insert,jump,mark,percent,quickfix,search,tag,undo
set formatoptions=rqn1j2
if executable("rg")
  set grepprg=rg\ --vimgrep
  set grepformat=%f:%l:%c:%m
endif
set hidden
set history=100
set hlsearch
set ignorecase
set incsearch
set langmenu=en
set laststatus=2
set list
set listchars=tab\:>-,trail\:~,precedes\:<,extends\:>,nbsp:+
set linebreak
set makeprg=make\ -rR
set matchpairs=(:),{:},[:],<:>
set modeline
set mouse=a
set nowrap
set nrformats=alpha,hex,unsigned
set number
set path=**,.,,
set ruler
set scrollback=100000
set scrolloff=3
set sidescrolloff=3
set shellpipe=2>&1\|tee
set shiftround
set shiftwidth=4
if has('win32') || has('win64')
    set shell=bash
    set shellcmdflag=-c
    set shellquote=
    set shellxquote=
    set noshelltemp
    set shellslash
endif
set shortmess=atIT "c
set showcmd
set showmode
set showbreak=\
set smartcase
set smartindent
set smarttab
set softtabstop=4
set spell
set spelllang=en
set statusline=%<%f%(\ [%{SCVCSStatusLine()}]%)%=%(\ [%M%R%H%W%q]%)\ [%Y,%{&enc},%{&ff}]\ %6(%c%V,%l%)%(\ %P%)\ "Comment to protect WS at EOL
set tabpagemax=20
set tabstop=4
set tags=.tags
set textwidth=80
set notimeout
set timeoutlen=2000
set notimeout
set title
set undofile
set undolevels=1000
set undoreload=1000
set updatetime=300
set viminfo='200,<50,s10,h,rA:,rB:,h,
set virtualedit=all
set wildignore=**__pycache__**
set wildmenu
set wildmode=longest:full,full
set winheight=15
set winminheight=7
set wrapscan

" }}}

" Functions {{{

" MAKE {{{
function! Make(bang, cmdOrTargets)
    """ Write current buffer if edited,
    """ execute make or other program in terminal in previewwindow
    """ go to Preview Window, scroll to End, install callback when Done
    """ Go back to currently edited File

    if a:bang == '!'
        let cmd = a:cmdOrTargets
    else
        let cmd = &makeprg.' '.a:cmdOrTargets
    endif
    let cmd = '('.expandcmd(cmd).' ; exit ${PIPESTATUS[0]} ; ) 2>&1 |tee .makelog ; exit ${PIPESTATUS[0]} ;'
    let g:Make_last_Command = cmd
    wall
    wincmd z
    cclose
    silent botright pedit! +setlocal\ buftype=nofile\ nobuflisted\ noswapfile\ nolist\ nohlsearch MAKE
    wincmd P
    let buf=bufnr('%')
    call termopen(cmd, {
          \ 'on_exit': 'Make_____Done',
          \ 'buf': buf,
          \})
    normal G
    wincmd p
endfunction

function! Make_____Done(job_id, return_code, event) dict
  " open make log anyways to get quick fix for warnings
  wincmd z
  cgetfile .makelog
  call QFSigns()
  botright copen

  if a:return_code == 0
    echo "✅ Make Successful"
    normal G
  else
    echo "🟥 Make Failed ".a:return_code
    cc
  endif

  wincmd w
  exe self.buf.'bwipe!'
endfunction

" }}}

" Navigate {{{
python3 << EOF

"""Better <C-X><C-F> Filename Completion.


Complete Files relative to each directory, from current file to CWD
Using an increasing set of characters
"""

import re
from pathlib import Path

FILE_REs = [
    re.compile(r"[a-z0-9_./\\]*$", re.IGNORECASE),
    re.compile(r"[a-z0-9_./\\ ]+$", re.IGNORECASE),
    re.compile(r"[a-z0-9_./\\ =]+$", re.IGNORECASE),
    re.compile(r"""[a-z0-9_./\\ ='"]+$""", re.IGNORECASE),
    re.compile(".+$"),
]


def find_file_like(line):
    """Find File-like substrings with increasing character set"""

    result = []
    for r in FILE_REs:
        m = r.search(line)
        if m:
            if m[0] not in result:
                result.append(m[0])
    return result


def test_find_file_like():
    assert find_file_like("f='a b/c.d") == ["b/c.d", "a b/c.d", "f='a b/c.d"]
    assert find_file_like("f= a") == ["a", " a", "f= a"]
    assert find_file_like("f= ") == ["", " ", "f= "]


def glob_relative(relative_file, prefix):
    """Find Files in relative_file's parents"""

    pattern = f"{prefix}*"
    result = []
    file = Path(relative_file)
    while file.parent != file:
        r = []
        for p in file.parent.glob(pattern):
            s = p.relative_to(file.parent).as_posix()
            if p.is_dir():
                s+="/"
            r.append(s)
        file = file.parent
        result += sorted(r)
    return result


def test_glob_relative():
    assert glob_relative("after/ftplugin/c.vim", "f") == [
        "ftplugin",  # first, as nested deeper
        "file_complete.py",  # later
    ]


def find_suggestions(relative_file, prefixes):
    for prefix in prefixes:
        matches = list(glob_relative(relative_file, prefix))
        if matches:
            yield prefix, matches


def complete_file(relative_file, line):
    prefix_and_matches = []
    prefixes = find_file_like(line)
    prefix_and_matches = find_suggestions(relative_file, prefixes)
    prefix_and_matches = sorted(prefix_and_matches, key=lambda p: -len(p[0]))

    if not prefix_and_matches:
        return len(line), []
    longest_prefix = len(prefix_and_matches[0][0])

    start_column = len(line) - longest_prefix

    results = []
    for prefix, matches in prefix_and_matches:
        for m in matches:
            results.append(line[start_column : -len(prefix)] + str(m))
    return start_column, results


def test_complete_file():
    assert complete_file("after/ftplugin/c.vim", " x=a f") == (
        3,
        ["a file with spaces", "a ftplugin", "a file_complete.py"],
    )


EOF

function! CompleteFile()
    let file = expand("%")
    let line_no = line(".")
    let col_no = col(".")
    let line = getline(line_no)[:col_no]
    let completions = py3eval("complete_file('".file."', '".line."')")
    call complete(completions[0], completions[1])
    return ""
endfunction

function! JumpToLastEdit()
    if -1 != index(['gitcommit','gitrebase'], &filetype)
        return
    endif
    if -1 != index(['help','nofile','quickfix'], &buftype)
        return
    endif
    if &diff != 0
        return
    endif
    try
        keepjumps normal! g`"zv
    catch /.*/

    endtry
endfunction

function! FindBuildFile(bang)
    if a:bang != '!'
        return FindInParent(expand("%"), "Makefile")
    fi
    return Makefile
endfunction

python3 << EOF
import pathlib

def FindInParent(start, file):
  p = pathlib.Path(start)

  f = p/file
  if f.exists():
    return f
  while p.parent != p:
    p = p.parent
    f = p/file
    if f.exists():
      return str(f)
  return ""
EOF
function! FindInParent(start, file)
  return py3eval("FindInParent('".a:start."', '".a:file."')")
endfunction

function! GetFilenameAndLine()
    let line_no = line(".")
    let file_name = expand("%")
    let text = getline(line_no)
    return file_name."\nLine ".line_no.":\n".text
endfunction

function! AllZemMatches(term)
    let list=[]
    let matches = ZemGetMatches(a:term, 20)
    for m in matches
      if m['location'][0] == "/"
        let e = { "filename": m['file'], 'pattern':m['location'][1:-2], 'text':m['name'], 'valid':1 }
      else
        let e = { "filename": m['file'], 'lnum':m['location'], 'text':m['name'], 'valid':1 }
      endif
      call add(list, e)
    endfor
    call setqflist([], ' ', {"title":a:term, 'items':list, 'nr':'$'})
endfunction

" }}}

" Status Line {{{

function! GetStatusLine()
    return ""
endfunction

function! SCVCSStatusLine()
    if ! exists( "b:status" )
        let b:status = GetStatusLine()
    endif
    return b:status
endfunction

function! UpdateSCVCSStatusLine()
    if exists( "b:status" )
        unlet b:status
    endif
endfunction

" }}}

" {{{ QuickFix


function! QFErrorResolve()
    echoerr "QFErrorResolve not implemented for ".&ft
    " implemented in filetypes
endfunction

" }}}

" Useful {{{

sign define Check text=!> linehl=
sign define HL text=OK linehl=

function! QFSigns()
    sign unplace *
    let i = 1
    for d in getqflist()
        if (d.bufnr == 0 || d.lnum == 0)
            continue
        endif
        execute ":sign place ".i." line=".d.lnum." name=Check buffer=".d.bufnr
        let i = i + 1
    endfor
endfunction

" sudo write
function! SudoWrite()
    w ! sudo dd of="%"
    e!
    redraw
endfunction

function! TextObjComment(inner)
    " /*aaa*/   x
    let l = getline('.')
    let p = getpos('.')[2]

        if  l[p-2:p-1]   == '/*'
        normal l
    elseif  l[p-1:p]   == '/*'
        normal ll
    elseif  l[p:p+1]   == '/*'
        normal lll
    elseif  l[p-2:p-1] == '*/'
        normal h
    elseif  l[p-3:p-2] == '*/'
        normal hh
    endif

    if a:inner
        normal [/llv]/hh
    else
        normal [/v]/
    endif
endfunction

function! EditSibling(bang,...)
    let s = "tabedit  %:p"
    for i in range(1,a:0,2)
        let rep = a:000[i-1]
        let with = a:000[i]
        if a:bang == "!"
            let s = s . ":gs#\<".rep."\>#".with."#"
        else
            let s = s . ":gs#".rep."#".with."#"
        endif
    endfor
    exe s
endfunction

function! DiffSibling(bang,...)
    let s = "vert diffsplit %:p"
    for i in range(1,a:0,2)
        let rep = a:000[i-1]
        let with = a:000[i]
        if a:bang == "!"
            let s = s . ":gs#\<".rep."\>#".with."#"
        else
            let s = s . ":gs#".rep."#".with."#"
        endif
    endfor
    exe s
endfunction


function! MatchAdd(s)
    if ! exists('g:MatchPattern') || g:MatchPattern==""
        let g:MatchPattern = a:s
    else
        let g:MatchPattern .= '\|'.a:s
    endif

    highligh Match guibg=#c4c4c4 guifg=#000066
    exe 'match Match /'.g:MatchPattern.'/'
endfunction

function! ClearMatches()
    let g:MatchPattern = ''
    match
endfunction

function! ClearHighlights()
    lua vim.lsp.buf.clear_references()
endfunction

function! AutoChmod(fn)
    try
        if "#!/" == nvim_buf_get_lines(bufnr(a:fn),0,1,0)[0][0:1]
            call system(["chmod","+x",a:fn])
        endif
    catch /.*/
    endtry
endfunction

" }}}

" python stuff {{{
if has('python3')
python3 << EOF
import os.path
import re
import vim

RELATED_FILE_RES = [

    ]

def get_related_file(path):
    for f,tl in RELATED_FILE_RES:
        if re.search(f,path):
            if len(tl) > 1:
                for t in tl:
                    nf = re.sub(f,t,path)
                    if os.path.exists(nf):  # return 1st replace that exists
                        return nf
            return re.sub(f,tl[0],path) # return 1st replace
    raise ValueError(path)

def edit_related_file():
    path = vim.eval("expand('%')")
    try:
        r = get_related_file(path)
    except ValueError:
        print("No Pattern matched "+path)
    else:
        try:
            vim.command(":edit " + r)
        except vim.error as e:
            print (e)

CHAR_PAIRS = {
    "'" :   '"' ,
    '"' :   "'" ,
    '(' :   "[" ,
    '[' :   "{" ,
    '{' :   "(" ,
    ')' :   "]" ,
    ']' :   "}" ,
    '}' :   ")" ,
    '>' :   "<" ,
    '<' :   ">" ,
    '\\':   "/" ,
    '/' :   "\\",
    '|' :   "&" ,
    '&' :   "|" ,
    '+' :   "-" ,
    '-' :   "+" ,
}

def toggle_char():
    w = vim.current.window
    b = vim.current.buffer
    row,col = w.cursor
    l = b[row-1]
    c = l[col]
    nc = CHAR_PAIRS.get(c,c)
    print(c+" => "+nc)
    l = l[:col] + nc + l[col+1:]
    b[row-1] = l

EOF
endif
" }}}

" Commands {{{

command!                                 Abort           :call rpcnotify(b:nvr[0], 'Exit', 1)
command!        -nargs=? -complete=file  AF              :exe ":normal a".<q-args>
command! -bang  -nargs=+                 DS              :call DiffSibling(<q-bang>, <f-args>)
command! -bang  -nargs=+                 ES              :call EditSibling(<q-bang>, <f-args>)
command!                                 FileIdent       :call FileIdent()
command!                                 Mkdir           :exe "!mkdir -p ".expand("%:h")
command!                                 MKDIR           :exe "!mkdir -p ".expand("%:h")
command! -bang  -nargs=*  -complete=file Make            :call Make(<q-bang>, <q-args>)
command!                                 RM              :!rm -f %
command!        -nargs=1  -complete=file Rename          :let b:_old_f=expand("%") | :file <args> | :call system("mkdir -p ".expand("%:h")) |  :w | :e | :call system("rm -f ".b:_old_f)
command!                                 Source          :source $MYVIMRC | :silent source .nvimrc | :e
command!                                 Suw             :call SudoWrite()
command!        -nargs=1                 DefaultFile     :if argc()==0&&bufnr()==1 | :find <args> | :endif

command!                                 Build           :Make
command!                                 Test            :Make test
command!                                 Check           :Make check

function! LspCommands()

command! -buffer -nargs=0 LspAction                lua vim.lsp.buf.code_action()
command! -buffer -nargs=0 LspCallsInc              lua vim.lsp.buf.incoming_calls()
command! -buffer -nargs=0 LspCallsOut              lua vim.lsp.buf.incoming_calls()
command! -buffer -nargs=0 LspClearReferences       lua vim.lsp.buf.clear_references()
command! -buffer -nargs=0 LspDeclaration           lua vim.lsp.buf.declaration()
command! -buffer -nargs=0 LspDefinition            lua vim.lsp.buf.definition()
command! -buffer -nargs=0 LspDocumentHighlight     lua vim.lsp.buf.document_highlight()
command! -buffer -nargs=0 LspFormatting            lua vim.lsp.buf.formatting()
command! -buffer -nargs=0 LspHover                 lua vim.lsp.buf.hover()
command! -buffer -nargs=0 LspImplementation        lua vim.lsp.buf.implementation()
command! -buffer -nargs=? LspListDocumentSymbols   lua vim.lsp.buf.document_symbol(<q-args>)
command! -buffer -nargs=? LspListWorkspaceSymbols  lua vim.lsp.buf.workspace_symbol(<q-args>)
command! -buffer -nargs=0 LspNextDiagnostic        lua vim.diagnostic.goto_next()
command! -buffer -nargs=0 LspPrevDiagnostic        lua vim.diagnostic.goto_prev()
command! -buffer -nargs=0 LspQfList                lua vim.diagnostic.setqflist()
command! -buffer -nargs=0 LspReferences            lua vim.lsp.buf.references()
command! -buffer -nargs=0 LspRename                lua vim.lsp.buf.rename()
command! -buffer -nargs=0 LspSymbol                lua vim.lsp.buf.workspace_symbol()
command! -buffer -nargs=0 LspSignatureHelp         lua vim.lsp.buf.signature_help()
command! -buffer -nargs=0 LspTypeDefinition        lua vim.lsp.buf.type_definition()

endfunction
" }}}

" Mappings {{{

nnoremap <leader>#           :s/\s*\/\*[^*]*\*\///<CR>:nohlsearch<CR>
nnoremap <leader>;           :s/;.*//<CR>:nohlsearch<CR>
nnoremap <leader>,           <C-^>
nnoremap         -           :python3 toggle_char()<cr>
vnoremap <leader>/           :<C-U>let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>gvy:let @/='\V'.escape(getreg('"'), '\')<CR>:call setreg('"', old_reg, old_regtype)<CR>:set hlsearch<CR>
nnoremap <leader>/           :set hlsearch<CR>:let @/='\<<C-R><C-W>\>'<CR>
nnoremap         <C-\>       :ZemEdit !<C-R><C-W><CR>zz
nnoremap <leader><C-\>       :ZemEdit =P =D !<C-R><C-W><CR>zz
nnoremap         <C-B>       :exe ":sign place ".bufnr("%")."200".line(".")." name=HL line=".line(".")." file=".expand("%:p")<CR>mMj
nnoremap         cc          yiw
inoremap         <C-F>       <C-R>=CompleteFile()<CR>
nnoremap         <C-L>       <cmd>call ClearHighlights()<CR><cmd>call ClearMatches()<CR><C-L><cmd>set hlsearch<CR><CMD>nohlsearch<CR>
nnoremap         <C-N>       :exe ":sign unplace ".bufnr("%")."200".line(".")<CR>
nnoremap         <C-P>       :ZemPreviewEdit !<C-R><C-W><CR>
cnoremap         <C-R><C-R>  <C-R>+
inoremap         <C-R><C-R>  <C-R>+
nnoremap         <C-S>       :wa<CR>
inoremap         <C-S>       <ESC>:update<CR>
inoremap         <C-SPACE>   <C-X><C-U>
nnoremap         <C-W>a      :cclose<CR>
tnoremap         <Esc>       <C-\><C-n>
nmap             <F2>        :cprev<CR><F3>
nmap     <leader><F2>        :cpf<CR><F3>
nnoremap         <F3>        zz<cmd>let b:cc=execute(':cc')<CR><cmd>cc<CR>zz
nmap     <leader><F3>        :call QFErrorResolve()<CR>
tmap     <leader><F3>        <cmd>cbuffer<CR><F3>
nmap             <F4>        :cnext<CR><F3>
nmap     <leader><F4>        :cnf<CR><F3>
imap             <F2>        <ESC><F2>
imap             <F3>        <ESC><F3>
imap             <F4>        <ESC><F4>
imap             <F5>        <ESC><F5>
imap             <F6>        <ESC><F6>
imap             <F7>        <ESC><F7>
nnoremap         <F5>        :Build<CR>
nnoremap <leader><F5>        <cmd>BuildAll<CR>
nnoremap         <F6>        :Test<CR>
nnoremap <leader><F6>        <cmd>TestAll<CR>
nnoremap         <F7>        gg:Check<CR>
nnoremap <leader><F7>        gg:CheckAll<CR>
nnoremap <leader><leader>    :silent python3 edit_related_file()<CR>
vnoremap         >           >gv
vnoremap         <           <gv
nnoremap <leader>?           :call MatchAdd("<C-R><C-W>")<CR>
vnoremap <leader>?           y:call MatchAdd("<C-R>"")<CR>
nnoremap <leader>A           vip:EasyAlign*\ {'indentation':'shallow', 'ignore_groups':[]}<CR>
nmap     <leader>a           vip<Plug>(LiveEasyAlign)
vnoremap <leader>A           :EasyAlign*\ {'indentation':'shallow', 'ignore_groups':[]}<CR>
vmap     <leader>a           <Plug>(LiveEasyAlign)
onoremap         a*          :<C-U>call TextObjComment(0)<CR>
vnoremap         a*          <ESC>:<C-U>call TextObjComment(0)<CR>
nnoremap <leader>b           :Breakpoint <CR>
nnoremap <leader>C           <C-W>z:%argdel<CR>:%bd<CR>
nnoremap <leader>c           <C-W>z:bd<CR>
nnoremap <leader>dg          :diffget<CR>
vnoremap <leader>dg          :diffget<CR>
nnoremap <leader>dr          :diffget REMOTE<CR>
nnoremap <leader>dl          :diffget LOCAL<CR>
nnoremap <leader>db          :diffget BASE<CR>
vnoremap <leader>dr          :diffget REMOTE<CR>
vnoremap <leader>dl          :diffget LOCAL<CR>
vnoremap <leader>db          :diffget BASE<CR>
nnoremap <leader>dp          :diffput<CR>
vnoremap <leader>dp          :diffput<CR>
nnoremap <leader>du          :diffupdate<CR>
nnoremap <leader>dt          :diffthis<CR>
nnoremap <leader>e           O<c-a> = <Esc>p
nnoremap <leader>G           <cmd>tab Git<CR>
nnoremap         gz          :ZemEdit !<C-R><C-W><CR>zz
nnoremap <leader>H           :e <C-R>=expand("%:h")<CR>/
nnoremap <leader>i           :Import<CR>
onoremap         i*          :<C-U>call TextObjComment(1)<CR>
vnoremap         i*          <ESC>:<C-U>call TextObjComment(1)<CR>
nnoremap <leader>l           :let @+ = GetFilenameAndLine()<CR>
nnoremap <leader>m           :exe 'edit '.FindBuildFile("")<CR>
nnoremap <leader>M           :exe 'edit '.FindBuildFile("!")<CR>
nnoremap <leader>n           :bn<CR>
nnoremap <leader>N           :bp<CR>
nnoremap         Q           @q
vnoremap         Q           @q
vnoremap <leader>r,          :<C-U>let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>gv""s<C-R>=join(reverse(split(@",'\s*,\s*')),', ')<CR><ESC>:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <leader>r=          :<C-U>let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>gv""s<C-R>=join(reverse(split(@",'\s*=\s*')),' = ')<CR><ESC>:call setreg('"', old_reg, old_regtype)<CR>
nnoremap <leader>R           :Rename <C-R>=expand("%")<CR>
vnoremap <leader>s           ""y:%s/<C-R>=substitute(escape(@", '?\.*$^~[/'), '\_s\+', '\\_s\\+', 'g')<CR>/<C-R>=substitute(escape(@", '?\.*$^~[/'), '\_s\+', '\\_s\\+', 'g')<CR>/gc<left><left><left>
nnoremap <leader>s           ""yiw:%s/\<<C-R>=substitute(escape(@", '?\.*$^~[/'), '\_s\+', '\\_s\\+', 'g')<CR>\>/<C-R>=substitute(escape(@", '?\.*$^~[/'), '\_s\+', '\\_s\\+', 'g')<CR>/gc<left><left><left>
noremap  <leader>S           :%s/[ \r\t]\+$//e<CR>
nnoremap <leader>T           :tabedit<CR>:terminal<CR>
nnoremap <leader>t           :tabnew<CR>:set buftype=nofile<CR>
nnoremap <leader>v           <cmd>grep "\b<C-R><C-W>\b"
nnoremap         Z           :Zem<CR>
nnoremap         z0          :set foldlevel=99<CR>
nnoremap         z1          :set foldlevel=0<CR>
nnoremap         z2          :set foldlevel=1<CR>
nnoremap         z3          :set foldlevel=2<CR>
nnoremap         z4          :set foldlevel=3<CR>
nnoremap <leader>zd          :ZemEdit =Proto =Def !<C-R><C-W><CR>
nnoremap <leader>ze          :ZemEdit <C-R><C-W><CR>
nnoremap <leader>zf          :ZemEdit /<C-R><C-F><CR>
nnoremap <leader>zi          :call FixMissingInclude("<C-R><C-W>")<CR>
nnoremap <leader>zp          :ZemPreviewEdit !<C-R><C-W><CR>
nnoremap <leader>zt          :ZemTabEdit !<C-R><C-W><CR>
nnoremap <leader>zu          :ZemUpdate<CR>
nnoremap <leader>zU          :Zem =Use !<C-R><C-W>
nnoremap <leader>zz          :Zem !<C-R><C-W><CR>
nnoremap <leader>za          :call AllZemMatches("!<C-R><C-W>")<CR>
nnoremap         <C-1>       1<C-W><C-W>
nnoremap         <C-2>       2<C-W><C-W>
nnoremap         <C-3>       3<C-W><C-W>
nnoremap         <C-4>       4<C-W><C-W>
nnoremap         <C-5>       5<C-W><C-W>
nnoremap         <C-6>       6<C-W><C-W>
inoremap         <C-1>       <ESC>1<C-W><C-W>
inoremap         <C-2>       <ESC>2<C-W><C-W>
inoremap         <C-3>       <ESC>3<C-W><C-W>
inoremap         <C-4>       <ESC>4<C-W><C-W>
inoremap         <C-5>       <ESC>5<C-W><C-W>
inoremap         <C-6>       <ESC>6<C-W><C-W>


" terminals are dumb, C-H is C-BS.
inoremap        <C-H>       <c-W>
inoremap        <C-BS>      <c-W>
inoremap        <C-W>       <cmd>echo "DONT"<CR>
cnoremap        <C-H>       <c-W>
cnoremap        <C-BS>      <c-W>
cnoremap        <C-W>       <cmd>echo "DONT"<CR>

"vip:'<,'>sort /\%28v/

function! LspMappings()

nnoremap <buffer>        <C-k>       <cmd>lua vim.lsp.buf.signature_help()<CR>
inoremap <buffer>        <C-k>       <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <buffer> <space>/           <cmd>lua vim.lsp.buf.document_highlight()<CR>
nnoremap <buffer> <space>d           <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <buffer> <space>a           <cmd>lua vim.lsp.buf.code_action()<CR>
vnoremap <buffer> <space>a           <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <buffer> <space>e           <cmd>lua vim.diagnostic.open_float({scope="line"})<CR>
nnoremap <buffer> <space>f           <cmd>lua vim.lsp.buf.format()<CR>
vnoremap <buffer> <space>f           <cmd>lua vim.lsp.buf.format()<CR>
nnoremap <buffer> <space>q           <cmd>lua vim.diagnostic.setqflist()<CR>
nnoremap <buffer> <space>r           <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <buffer> <space>s           <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <buffer> <space>wa          <cmd>lua vim.lsp.buf.add_workspace_folder()<CR>
nnoremap <buffer> <space>wl          <cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>
nnoremap <buffer> <space>wr          <cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>
nnoremap <buffer>        K           <Cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <buffer>        [d          <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <buffer>        ]d          <cmd>lua vim.diagnostic.goto_next()<CR>
nnoremap <buffer>        gD          <Cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <buffer>        gd          <Cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <buffer>        gi          <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <buffer>        gr          <cmd>lua vim.lsp.buf.references()<CR>

endfunction

" }}}

" {{{ Abbreviations

cabbr <expr> %% expand('%')
cabbr <expr> %H expand('%:h')
cabbr <expr> %P expand('%:p')
cabbr <expr> %R expand('%:r')
cabbr <expr> %T expand('%:t')

" }}}

" LSP {{{

lua << EOF
function on_attach(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    vim.api.nvim_buf_set_option(bufnr, 'formatexpr', 'v:lua.vim.lsp.formatexpr(#{timeout_ms:500})')
    vim.fn['LspMappings']()
    vim.fn['LspCommands']()
end

vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        update_in_insert = false,
        underline = false,
        severity_sort = true,
})


local lspconfig = require'lspconfig'

lspconfig.pylsp.setup { -- pip install pyls-flake8 pyls-isort python-lsp-black python-lsp-server
    on_attach = on_attach,
    settings = {
        pylsp = {
            configurationSources = {"flake8"},
            formatCommand = {"black"},
            plugins = {
                flake8 = {
                    enabled=true,
                    ignore={'E1', 'E2', 'E3', 'E5', "E74", 'W1', 'W2', 'W3', 'W5'},
                    maxLineLength=25,
                },
                isort = {
                    enabled=true, -- snakeoil?
                },
            }
        },
    },
}

lspconfig.rust_analyzer.setup { -- cargo install rust-analyzer
    on_attach = on_attach,
     settings = {
         ["rust-analyzer"] = {
             imports = {
                granularity = {
                    group = "item"
                }
             },
             cargo = {
                 allFeatures = true,
                 loadOutDirsFromCheck = true,
             },
             completion = {
                  autoimport = {
                      enabled = true,
                  },
              },
             procMacro = {
                 enable = true
             },
             checkOnSave = {
                 allTargets = false,
             },
         }
     }
}

-- require"rust-tools".setup{
--   server = {
--     on_attach = function(_, bufnr)
--      --   vim.api.nvim_buf_set_option(bufnr, 'formatexpr', 'v:lua.vim.lsp.formatexpr(#{timeout_ms:500})')
--         vim.fn['LspMappings']()
--         vim.fn['LspCommands']()
--
--       -- Hover actions
--       vim.keymap.set("n", "K", require"rust-tools".hover_actions.hover_actions, { buffer = bufnr })
--       -- Code action groups
--       vim.keymap.set("n", "<space>a", require"rust-tools".code_action_group.code_action_group, { buffer = bufnr })
--     end,
--     }
-- }

lspconfig.clangd.setup { -- install clang somehow?
    on_attach = on_attach,
    cmd = {
        "clangd",
        "--clang-tidy",
        "--cross-file-rename",
        "--header-insertion=iwyu",
        "--log=info",
    },
    root_dir = function (fname)
      return lspconfig.util.root_pattern("compile_flags.txt")(fname) or "."
    end
}

for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
      vim.api.nvim_set_hl(0, group, {})
end
EOF
" }}}
"

if filereadable(expand('<sfile>:h').'/local.vim')
    exe "source ".expand('<sfile>:h').'/local.vim'
endif

" vim:foldmethod=marker:
set secure
nohlsearch
