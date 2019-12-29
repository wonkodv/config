function _colorprompt_ssh() {
    # white on blue
    if [ -n "$SSH_CLIENT" ]
    then
        echo -n " \[\e[0;37;44m\]SSH\[\e[0m\]"
    fi
}
_colorprompt_add _colorprompt_ssh
