function _prompt() {
    if [ "$?" -ne "0" ]
    then
        PS1="\[\e[0;37;41m\];\[\e[0m\] "
    else
        PS1="; "
    fi
}
PROMPT_COMMAND='_prompt'
