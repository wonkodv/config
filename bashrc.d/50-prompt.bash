PS0="\e[m"
PS1='$(rc=$?; [ $rc != 0 ] && echo "\[\e[0;31m\] => $rc" && echo "\[\e[0\]" )\[\e]0;\u@\h:\w\a\e[30;49;8m\]: \[\e[m\e[;34m\]; '
