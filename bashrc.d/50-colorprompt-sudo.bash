function _colorprompt_sudo() {
    # white on blue
    if ! [ -z "$SUDO_USER" ]
    then
        echo -n " \[\e[0;37;44m\]sudo\[\e[0m\]"
    fi
}
_colorprompt_add _colorprompt_sudo
