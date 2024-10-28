command! -buffer Build :Make! latexmk
command! -buffer Test  :Make! evince %:r.pdf
command! -buffer Check :echoerr 'Not implemented'
