if getfsize(expand("%")) < 1000000
  setlocal foldmethod=syntax
else
  setlocal foldmethod=indent
endif
setlocal formatoptions-=c
setlocal formatoptions-=o

setlocal cindent
setlocal formatoptions-=c
setlocal formatoptions-=o

let b:vgExt = "*.{c,cpp,cc,h,asm,s,sct,lds,icf}"
setlocal wildignore+=**/obj/**
setlocal wildignore+=**\\obj\\**
setlocal wildignore+=*.o
setlocal wildignore+=*.out
setlocal wildignore+=*.a
setlocal wildignore+=*.elf

command! -buffer BreakpointScoped execute "T32 B.S \\".expand("%:t:r")."\\".expand("<cword>")
command! -buffer Breakpoint T32 B.s <cword>
command! -buffer Import :normal ?^#include<CR>:nohl<CR>o#include "

command! Build           :Make
command! Test            :Make test
command! Check           :EOFix

function! FindBuildFile(bang)
    if a:bang == "!"
        return expand("%:h").'/CMakeLists.txt'
    endif
    let m = FindInParent(expand("%"), "CMakeLists.txt")
    if m != ""
      return m
    endif
    m = FindInParent(expand("%"), "Makefile")
    if m != ""
      return m
    endif
    return "Makefile"
endfunction

set errorformat=
" Make Enter and exit dir
set errorformat+=%Dmake[%\\d]:\ Entering\ directory\ '%f'
set errorformat+=%Xmake[%\\d]:\ Leaving\ directory\ '%f'
" make[1]: *** [Makefile:12: obj/foo.o] Error 42
set errorformat+=make[%*\\d]:\ ***\ [%f:%l:\ %m
" make: *** [Makefile:12: obj/foo.o] Error 42
set errorformat+=make:\ ***\ [%f:%l:\ %m

" gtest failure
set errorformat+=%\\d:\ %f:%l:\ %m
" gnu file:line:column: message
set errorformat+=In\ file\ included\ from\ %f:%l:%c:
set errorformat+=%f:%l:%c:\ %m
set errorformat+=%f:%l:%c:
" gnu file:line: message
set errorformat+=%f:%l:\ %m
" gnu file:line:
set errorformat+=%f:%l:\ " comment to protect ws at eol

" iar
set errorformat+=\"%f\"\\,%l\ %m
set errorformat+=%m\ at\ line\ %l\ of\ \"%f\"

" CMake
set errorformat+=CMake\ Error\ at\ %f:%l\ %m


iabbrev defien define
iabbrev if0    if 0

python3 << EOF

RELATED_FILE_RES = [

        [r"_a\.(asm|s)$", [".c", ".cpp","_a.h",".h"]],          # lib_a.s   => lib.c | lib_a.h | lib.h
        [r"\.(c|cpp|asm|s|cxx)$", [".h", ".hpp"]],                      # lib.{c,s} => lib.h
        [r"\.h(xx|pp|)$", [".c", ".cpp", ".cxx", ".asm",".s","_a.asm","_a.s"]],  # lib.h     => lib.c | lib.s | lib_a.s
    ]
EOF

function! FixMissingInclude(ident)
    let m = ZemGetMatches("=Typ =Proto =Def !".a:ident,1)
    if  len(m) == 0
        echoerr "No Definition found ".a:ident
        return
    endif
    let m = m[0]['file']
    let f = substitute(m,'\\','/','g')
    let f = substitute(f,'.*/','','')
    exe '?^#include'
    exe 'normal o#include "'.f.'"'
    echo 'add #include "'.f.'"'
endfunction

function! QFErrorResolve()
    cclose
    let t = execute("cc")

    let m = matchlist(t, 'Repeated include file')
    if len(m) > 0
        normal dd
        echo "delete ".@1
        return
    endif

    "  [CID 534826] The variable "adc_digits" has a non-const type ...
    let m = matchlist(t, 'The variable "\(\w*\)" has a non-const type')
    if len(m) > 0
          exe 's/\ze\<'.m[1].'\>/const /'
        return
    endif

    " Declaring "oversample" without "constexpr".
    let m = matchlist(t, 'Declaring "\(\w*\)" without "constexpr"')
    if len(m) > 0
          exe 's/\<const\>/constexpr/'
        return
    endif

    " Initializing variable "emitter_cooldown_time_s" without using braced-initialization {}.
    let m = matchlist(t, 'Initializing variable "\(\w*\)" without using braced-initialization')
    if len(m) > 0
        exe 's/'.m[1].' *\zs=\(.*\);/{\1};/'
        return
    endif

    " "static_cast<float>(adc_digits) * vdda" should be parenthesized.
    let m = matchlist(t, '"\(.*\)" should be parenthesized')
    if len(m) > 0
        exe 's/\c\V\('.substitute(escape(m[1],'\/'), "->","..\\\\?","g").'\)/(\1)/'
        return
    endif

   //Declaring "operator" "=" without ref-qualifier "&". (Custom External Findings/coverity_autosar.A12-8-7)
    let m = matchlist(t, 'Declaring "operator" "=" without ref-qualifier ')
    if len(m) > 0
        normal $F=hi &
        return
    endif

    " The pointer variable "voltage" points to a non-constant type but does not modify the object it points to. Consider adding const qualifier to the points-to type.
    let m = matchlist(t, 'The pointer variable "\(.*\)" points to a non-constant type but does not modify the object it points to. Consider adding const qualifier to the points-to type')
    if len(m) > 0
        exe 's/\([&*] *'.m[1].'\)/ const\1/'
        return
    endif

    " The value assigned to variable `scheduling_disabled_guard` is never read
    let m = matchlist(t, 'The value assigned to variable `.*` is never read')
    if len(m) > 0
        exe 'normal I[[maybe_unused]] '
        return
    endif

    " (189 of 2428) info 766: Header file 'FILE.h' not used in module 'FILE.c'
    let m = matchlist(t, 'Header file .*\\\(\w*.h\). not used')
    if len(m) > 0
        try
            exe '?^#include.*'.m[1]
        catch /.*/
            return
        endtry
        normal dd
        echo "delete ".@1
        return
    endif

    " error: identifier "IDENT" is undefined ...
    let m = matchlist(t, 'identifier "\(\w*\)" is undefined')
    if len(m) < 0
        " warning: #225-D: function "FUNC" declared implicitly
        let m = matchlist(t, 'function "\(\w*\)" declared implicitly')
    endif
    if len(m) > 0
        let ident = m[1]
        call FixMissingInclude(ident)
        return
    endif

    " (8 of 13) error: struct "STRUCT" has no field "FIELD"
    let m = matchlist(t, 'struct "\(\w*\)" has no field "\(\w*\)"')
    if len(m) > 0
        let struct = m[1]
        let field = m[2]
        exe ':ZemEdit =Typ =Proto =Def !'.struct
        echo 'No Field "'.field.'" in struct "'.struct.'"'
        return
    endif

    "(595 aus 24107) info 715: Symbol 'SYM' (line 121) not referenced
    let m = matchlist(t, "Symbol '\\(.*\\)' .* not referenced")
    if len(m) > 0
        let symbol = m[1]
        exe 'normal O(void)'.symbol.';'
        return
    endif

    echoerr "Error can not be resolved: ".t
endfunction
