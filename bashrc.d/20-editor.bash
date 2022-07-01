# disable terminal reacting to <C-s>
stty -ixon 2>/dev/null
export EDITOR=${EDITOR:-$(which nvim)}
alias vim=$EDITOR
function vimgrep {
    $(EDITOR) -c "vimgrep '$1' **/*.${2:-*}"
}
