# _prompt_marker is defined by Editor
#PS0='\e[m$(_prompt_marker)'
PS0='\[\e[m\]'
# put command in title
#PS0="$PS0"'\e]0;\u@\h:\w' # : $(history -a; tail -1 ~/.bash_history)\a' adds full history after each command, spamming bash_history, if there are multiple bashs open


PS1=

# colored returncode
PS1="$PS1"'$(b=$(rc=$?; [ $rc != 0 ] && echo "=> $rc") && echo "\[\e[0;31m\]$b\[\e[m\]\n\n")' # $() strips one \n

# set title
PS1="$PS1"'\[\e]0;\u@\h:\w\a\]'

# start
PS1="$PS1"'\[\e[30;49;8m\]: '

# NIX
PS1="$PS1"'${IN_NIX_SHELL:+\[\e[0;36m\]NIX }'

# Git branch
PS1="$PS1"'$(b=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null) && echo "\[\e[0;35m\]$b ")'

# user@host
if [ -n "$SSH_TTY" ] || [ -n "${SUDO_USER}" ] ; then
    PS1="$PS1"'\[\e[0;33m\]\u\[\e[0;32m\]@\[\e[0;33m\]\h:'
fi

# CWD
PS1="$PS1"'\[\e[0;32m\]\w'

# ;
PS1="$PS1"'\[\e[0;34m\] ; '


readonly PS1 # a bit agressive, but meh
