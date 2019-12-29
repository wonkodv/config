function _colorprompt_trickle() {
    # White on Blue
    if [ "${LD_PRELOAD/*trickle*/}" != "${LD_PRELOAD}" ]
    then
        echo -n " \[\e[0;37;44m\]u${TRICKLE_UPLOAD_LIMIT}/d${TRICKLE_DOWNLOAD_LIMIT}kb/s\[\e[0m\])"
    fi
}
_colorprompt_add _colorprompt_trickle
