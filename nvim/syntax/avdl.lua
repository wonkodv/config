if vim.b.current_syntax then
  return
end

local cmd = vim.cmd

-- Keywords
cmd [[syntax keyword avdlKeyword protocol import idl schema throws oneway]]
cmd [[syntax keyword avdlStructure record enum error fixed]]
cmd [[syntax keyword avdlType void null boolean int long float double bytes
      \ string array map union date time_ms timestamp_ms local_timestamp_ms
      \ decimal uuid]]
cmd [[syntax keyword avdlBoolean true false]]
cmd [[syntax keyword avdlNull null]]

-- Literals
cmd [[syntax match  avdlNumber /\<-\?\d\+\(\.\d\+\)\?\([eE][+-]\?\d\+\)\?[fdlFDL]\?\>/]]
cmd [[syntax region avdlString start=+"+ skip=+\\\\\|\\"+ end=+"+]]

-- Annotations like @namespace, @order, @logicalType, @aliases
cmd [[syntax match avdlAnnotation /@\w\+/]]

-- Comments (doc comment region must be defined before normal block comment
-- so the longer match wins)
cmd [[syntax keyword avdlTodo contained TODO FIXME XXX NOTE]]
cmd [[syntax region  avdlDocComment   start=+/\*\*+ end=+\*/+ contains=avdlTodo,@Spell]]
cmd [[syntax region  avdlBlockComment start=+/\*+   end=+\*/+ contains=avdlTodo,@Spell]]
cmd [[syntax region  avdlLineComment  start=+//+    end=+$+   contains=avdlTodo,@Spell keepend]]

-- Trailing comma in enum bodies, parameter lists, and array literals.
-- Matches a comma followed by optional whitespace/newlines and a closer
-- (`}`, `)`, or `]`), but only highlights the offending comma itself.
cmd [[syntax match avdlTrailingComma /,\_s*[\]})]/me=s+1]]

-- Highlight links
local hl = function(group, link)
  cmd(string.format("highlight default link %s %s", group, link))
end

hl("avdlKeyword",        "Keyword")
hl("avdlStructure",      "Structure")
hl("avdlType",           "Type")
hl("avdlBoolean",        "Boolean")
hl("avdlNull",           "Constant")
hl("avdlNumber",         "Number")
hl("avdlString",         "String")
hl("avdlAnnotation",     "PreProc")
hl("avdlLineComment",    "Comment")
hl("avdlBlockComment",   "Comment")
hl("avdlDocComment",     "SpecialComment")
hl("avdlTodo",           "Todo")
hl("avdlTrailingComma",  "Error")

vim.b.current_syntax = "avdl"
