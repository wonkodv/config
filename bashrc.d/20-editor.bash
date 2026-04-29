if [ -n "$NVIM" ]; then
    # once nvr checks for $NVIM, the --servername can be removed
    export EDITOR="nvr --nostart --servername $NVIM --remote-tab-wait-silent"
    alias vim="nvr --nostart --servername $NVIM"
else
    export EDITOR=nvim
    alias vim=nvim
    function _prompt_marker {
        true
    }
fi
