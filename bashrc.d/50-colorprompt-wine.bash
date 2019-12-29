function _colorprompt_wine() {
    if [ "$WINEPREFIX" != "" ]
    then
        echo -n " \[\e[0;37;45m\]WINE\[\e[0m\]"
    fi
}
_colorprompt_add _colorprompt_wine
