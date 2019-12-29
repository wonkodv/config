function _colorprompt_job() {
    # white on blue
    local str=`jobs -p | wc -l`
    if [ "$str" != "0" ]
    then
        echo -n " \[\e[0;37;44m\]${str}Jobs\[\e[0m\]"
    fi
}
_colorprompt_add _colorprompt_job
