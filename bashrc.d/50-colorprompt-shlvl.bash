function _colorprompt_shlvl() {
    # White on Blue
    if [ "$SHLVL" -gt ${SHLVL_IGNORE:-2} ]
    then
        echo -n " \[\e[0;37;44m\]${SHLVL}\[\e[0m\]"
    fi
}
_colorprompt_add _colorprompt_shlvl
