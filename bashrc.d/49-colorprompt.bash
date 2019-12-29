PROMPT_COMMAND='PS1="`_colorprompt`"'

_colorprompt_functions=()

function _colorprompt_add() {
    _colorprompt_functions+=("$@")
}

function _colorprompt_test() {
    for f in "${_colorprompt_functions[@]}"
    do
        echo "$f"
        echo -n ">"
        $f
        echo "<"
    done
}

function _colorprompt() {
    export _colorprompt_return_code=$?

    status="$(for f in "${_colorprompt_functions[@]}"; do $f; done)"

    # Calculate length of Status Text
    local lstatus="`echo -n \"${status}\" | sed -e 's/\\\\\[[^]]*\\\\\]//g'`"
    lstatus=${#lstatus}

    if [ $COLUMNS -gt 80 ]
    then
        local len=80
    else
        local len=$COLUMNS
    fi
    len=$(($len-$lstatus+37));


    echo -n "\[\e[0;36m\]\A "       # green Time
    printf "%- ${len}s " "\[\e[0;33m\]$USER\[\e[0;36m\]@\[\e[33m\]$HOSTNAME:\[\e[36m\]$PWD"
    echo -n $status
    echo -n "\[\e[0m\]"             # clear
    echo                            # linebreak
    echo -n "\[\e[35m\]\! "         # History Number

    if [ "$USER" != 'root' ]
    then
        echo -n "\[\e[36m\]$ "      # green $
    else
        echo -n "\[\e[31m\]# "      # red #
    fi
    echo -n "\[\e[0m\]"				# clear
}
