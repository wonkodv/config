# clear color for output
PS0='\e[m'
# put command in title
PS0="$PS0"'\e]0;\u@\h:\w: $(history -a; tail -1 ~/.bash_history)\a'

# colored returncode
PS1='$(rc=$?; [ $rc != 0 ] && echo "\[\e[0;31m\] => $rc" && echo "\[\e[0m\]" )'
# set title
PS1="$PS1"'\[\e]0;\u@\h:\w\a\]'
#  prompt
PS1="$PS1"'\[\e[30;49;8m\]: \[\e[m\e[;34m\]; '
