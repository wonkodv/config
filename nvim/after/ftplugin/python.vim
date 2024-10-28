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

python3 << EOF
def Inspect(x):
    import inspect
    import vim
    import importlib
    o = __builtins__
    parts = []

    for part in x.split("."):
        parts.append(part)
        try:
            o = getattr(o,part)
        except AttributeError as ae:
            try:
                o = importlib.import_module(".".join(parts))
            except ImportError:
                raise ae from None

    o = inspect.unwrap(o)
    f = inspect.getsourcefile(o)
    p = vim.command("edit "+f)
    try:
        _, l = inspect.getsourcelines(o)
        vim.command("normal {}G".format(l))
    except TypeError:
        l = 0

RELATED_FILE_RES = (
    # test/bar/test_foo.py => bar/foo.py
    ( r"^test/(.*/)test_(\w*\.py)",   (r"\1\2",)),
    # bar/test_foo.py  => bar/foo.py
    ( r"\btest_(\w*\.py)",            (r"\1",)),
    # bar/foo.py => bar/test_foo.py test/bar/test_foo.py
    ( r"^(.*/)(\w*\.py)",             (r"\1test_\2", r"test/\1test_\2",)),
)
EOF

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

