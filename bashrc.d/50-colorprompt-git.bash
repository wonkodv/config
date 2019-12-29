function _colorprompt_git() {
    # white on {red,yellow,green}
    local git_status="`LC_ALL=C git status -unormal 2>&1`"
    if ! [[ "$git_status" =~ "not a git repo" ]]
    then
        if [[ "$git_status" =~ "nothing to commit" ]]
        then
            if [[ "$git_status" =~ "Your branch is ahead of" ]] ||
                [[ "$git_status" =~ "diverged" ]]
                        then
                            local color=43
                        else
                            local color=42
            fi
        else
            local color=41
        fi
        local branch="`git rev-parse --abbrev-ref HEAD 2>/dev/null`"
        echo -n " \[\e[00;30;${color}m\]$branch\[\e[0m\]"
    fi
}
_colorprompt_add _colorprompt_git
