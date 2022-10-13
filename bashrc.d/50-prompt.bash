PS0='\e[m'  # clear color for output
PS0="$PS0"'\e]0;\u@\h:\w # $(history -a; tail -1 ~/.bash_history)\a' # put command in title

PS1='$(rc=$?; [ $rc != 0 ] && echo "\[\e[0;31m\] => $rc" && echo "\[\e[0m\]" )' # colored returncode
PS1="$PS1"'\[\e]0;\u@\h:\w\a\]' # set title
PS1="$PS1"'\[\e[30;49;8m\]: \[\e[m\e[;34m\]; ' #  prompt
