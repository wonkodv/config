setlocal spell
setlocal spelllang=en
setlocal complete+=kspell
setlocal wrap
setlocal linebreak
setlocal textwidth=0
setlocal wrapmargin=3
setlocal comments=b:*,b:-,n:>
setlocal formatoptions+=r
setlocal formatoptions+=o

highlight SpellBad cterm=undercurl gui=undercurl

command! -buffer Build botright new term://typst watch --root . --open evince %
