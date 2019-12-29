function _colorprompt_returncode() {
    # white on red
    # needs retcode as 1st param
    ret=${_colorprompt_return_code:-BUG}
    if [ "$ret" -ne "0" ]
    then
        echo -n " \[\e[0;37;41m\]$ret\[\e[0m\]"
    fi
}
_colorprompt_add '_colorprompt_returncode'
