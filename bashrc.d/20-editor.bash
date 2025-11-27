if [ -n "$NVIM" ]; then
    # once nvr checks for $NVIM, the --servername can be removed
    export EDITOR="nvr --nostart --servername $NVIM --remote-tab-wait-silent"
    alias vim="nvr --nostart --servername $NVIM"
    function _prompt_marker {
        nvr --nostart --servername "$NVIM" -c ":mark p" &>/dev/null
        sleep 0.05
    }
elif [ -n "$NVIM_LISTEN_ADDRESS" ]; then
    export EDITOR="nvr --nostart --servername $NVIM_LISTEN_ADDRESS --remote-tab-wait-silent"
    alias vim="nvr --nostart --servername $NVIM_LISTEN_ADDRESS"
    function _prompt_marker {
        nvr --nostart --servername "$NVIM_LISTEN_ADDRESS" -c ":mark p" &>/dev/null
        sleep 0.05
    }
else
    export EDITOR=nvim
    alias vim=nvim
    function _prompt_marker {
        true
    }
fi
