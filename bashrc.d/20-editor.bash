# disable terminal reacting to <C-s>
stty -ixon 2>/dev/null

if [ -n "$NVIM_LISTEN_ADDRESS" ]
then
    export EDITOR="nvr --remote-tab-wait"
    alias vim="nvr --remote-tab"
else
    export EDITOR=/usr/bin/nvim
    alias vim=nvim
fi

function vimgrep {
    $(EDITOR) -c "vimgrep '$1' **/*.${2:-*}"
}

