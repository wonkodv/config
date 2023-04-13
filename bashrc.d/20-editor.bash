# disable terminal reacting to <C-s>
stty -ixon 2>/dev/null


alias vim=$EDITOR

if [ -n "$NVIM" ]
then
    # once nvr checks for $NVIM, the --servername can be removed
    export EDITOR="nvr --servername '$NVIM'"
    function _prompt_marker {
        nvr --servername "$NVIM" -c ":mark p" &>/dev/null
        sleep 0.05
    }
elif [ -n "$NVIM_LISTEN_ADDRESS" ]
then
    export EDITOR="nvr --servername '$NVIM_LISTEN_ADDRESS'"
    function _prompt_marker {
        nvr --servername "$NVIM_LISTEN_ADDRESS" -c ":mark p" &>/dev/null
        sleep 0.05
    }
fi
