if [ -n "$NVIM" ]; then
    # once nvr checks for $NVIM, the --servername can be removed
    export EDITOR="nvr --nostart --servername $NVIM --remote-tab-wait-silent"
    alias vim="nvr --nostart --servername $NVIM"
elif [ -n "$NVIM_LISTEN_ADDRESS" ]; then
    export EDITOR="nvr --nostart --servername $NVIM_LISTEN_ADDRESS --remote-tab-wait-silent"
    alias vim="nvr --nostart --servername $NVIM_LISTEN_ADDRESS"
else
    export EDITOR=nvim
    alias vim=nvim
    function _prompt_marker {
        true
    }
fi
