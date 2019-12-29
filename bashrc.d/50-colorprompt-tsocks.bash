function _colorprompt_tsocks() {
    # White on Yellow
    if [ "${LD_PRELOAD/*libtsocks*/}" != "${LD_PRELOAD}" ]
    then
        echo -n " \[\e[0;37;43m\]tsocks\[\e[0m\]"
    fi
}
_colorprompt_add _colorprompt_tsocks
