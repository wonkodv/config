" Vim syntax file for map files

if exists("b:current_syntax")
  finish
endif

syntax match mapComment "^#.*$"
syntax match mapNumber "\<[0-9']\+\>"
syntax match mapHexNumber "\<0x[0-9A-Fa-f']\+\>"

highlight link mapKeyword Keyword
highlight link mapComment Comment
highlight link mapNumber Number
highlight link mapHexNumber Number

let b:current_syntax = "map"
