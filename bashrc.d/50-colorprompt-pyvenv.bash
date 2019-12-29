function _colorprompt_pyvenv() {
    # white on blue
    if [ -n "$VIRTUAL_ENV" ]
    then
        echo -n " \[\e[0;37;44m\]$(basename $(dirname $VIRTUAL_ENV))\[\e[0m\]"
    fi
}
_colorprompt_add _colorprompt_pyvenv
