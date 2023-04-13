# _prompt_marker is defined by Editor
PS0='\e[m$(_prompt_marker)'
# colored returncode
PS1='$(rc=$?; [ $rc != 0 ] && echo "\[\e[0;31m\] => $rc" && echo "\[\e[0m\]" )'
# set title
PS1="$PS1"'\[\e]0;\u@\h:\w\a\]'
#  prompt
PS1="$PS1"'\[\e[30;49;8m\]: \[\e[0;32m\]\w \[\e[34m\]; '

