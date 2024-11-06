" Vim syntax file for IAR linker scripts (.icf)

if exists("b:current_syntax")
  finish
endif

syntax keyword icfKeyword define place with at from to rom object initialize
syntax keyword icfType ram region memory readonly readwrite code data section block
syntax match icfConstant "@\w\+@"

syntax match icfComment "//.*$" contains=icfTodo
syntax match icfComment "/\*.*\*/" contains=icfTodo
syntax region icfComment start="/\*" end="\*/" contains=icfTodo

syntax match icfString /"[^"]*"/

syntax match icfNumber "\<\d\+[kKmMgG]\?\>"
syntax match icfHexNumber "\<0x[0-9A-Fa-f]\+\>"

syntax keyword icfTodo TODO FIXME XXX

highlight link icfKeyword Keyword
highlight link icfType Type
highlight link icfConstant Constant
highlight link icfComment Comment
highlight link icfString String
highlight link icfNumber Number
highlight link icfHexNumber Number
highlight link icfTodo Todo

let b:current_syntax = "iarlinker"
