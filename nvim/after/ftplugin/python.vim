setlocal colorcolumn=100

function! PyBuild()
    let f = expand("%")
    call Make("!", "py ".f)
endfunction

function! PyBuildAll()
    call Make("!", "py .run.py")
endfunction

function! PyCheck()
    let f = expand("%")
    call Make("!", "py -m isort --profile black ".f." && py -m black ".f." && py -m flake8 ".f." --max-line-length=100 --ignore=E203,E211,E999,F401,F821,W503 --per-file-ignores=__init__.py:F401")
endfunction

function! PyCheckAll()
    call Make("!", "py -m isort --profile black . && py -m black . && py -m flake8 . --max-line-length=100 --ignore=E203,211,E999,F401,F821,W503 --per-file-ignores=__init__.py:F401")
endfunction

function! PyTest()
    let f = expand("%")
    " call Make("!", "py -m flake8 --select E9 && py -m pytest -v --doctest-modules -x ".f)
    call Make("!", "py -m pytest -vv --doctest-modules -x ".f)
endfunction

function! PyTestAll()
    call Make("!", "py -m pytest --doctest-modules .")
endfunction

command! -buffer Build call PyBuild()
command! -buffer Test  call PyTest()
command! -buffer Check call PyCheck()
command! -buffer BuildAll call PyBuildAll()
command! -buffer TestAll  call PyTestAll()
command! -buffer CheckAll call PyCheckAll()


abbrev <buffer> rnie raise NotImplementedError()
abbrev <buffer> ifmain if __name__ == '__main__':<CR>sys.exit(main(*sys.argv[1:]))
abbrev <buffer> modulelogger logger = logging.getLogger(__name__)


command! -buffer -nargs=1 PyInspect :python3 Inspect(<q-args>)
command! -buffer Breakpoint :normal Ibreakpoint()#TODO: BREAKPOINT  #<CR>


setlocal foldmethod=syntax
setlocal wildignore+=**.pyc
setlocal wildignore+=**/__pycache__/**
setlocal wildignore+=**\__pycache__\**
setlocal path=.,,./**

" gf in python module
setlocal includeexpr=(v:fname[0]=='.'?expand('%:p:h'):'').substitute(v:fname,'\\.','/','g')

" ignore <frozen> stacktraces
setlocal errorformat=%G\ \ File\ \"<frozen%.%#
" Start of a multiline Message, uses generic End
setlocal errorformat+=%A\ \ File\ \"%f\"\\,\ line\ %l%.%#
setlocal errorformat+=%Z\ \ \ \ %m
setlocal errorformat+=%f:%l:%c\%m
setlocal errorformat+=%f:%l:\ %m
let &errorformat.=",%f:%l: "

function! QFErrorResolve()
    cclose
    let t = execute("cc")

    "(10 aus 256): F401 'collections.abc' imported but unused
    let m = matchlist(t, "\\vF401 '((\\w|\\.)*)' imported but unused")
    if len(m) > 0
        try
            exe '?import  *'.m[1].'$'
        catch /.*/
            return
        endtry
        normal dd
        echo "delete ".@1
        return
    endif

    echoerr "Error can not be resolved: ".t
endfunction

