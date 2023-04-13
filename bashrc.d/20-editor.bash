# disable terminal reacting to <C-s>
stty -ixon 2>/dev/null
export EDITOR=${EDITOR:-$(which nvim)}
alias vim=$EDITOR
function vimgrep {
    $(EDITOR) -c "vimgrep '$1' **/*.${2:-*}"
}

function _prompt_marker {
    # Depricated
    if [ -n "$NVIM_LISTEN_ADDRESS" ]
    then
        nvr -c ":mark p" &>/dev/null
        sleep 0.05
    fi
    if [ -n "$NVIM" ]
    then
        nvr --server "$NVIM" -c ":mark p" &>/dev/null
        sleep 0.05
    fi
}
