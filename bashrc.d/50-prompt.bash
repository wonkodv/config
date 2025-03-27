# _prompt_marker is defined by Editor
PS0='\e[m$(_prompt_marker)'
PS0='\e[m'
# put command in title
#PS0="$PS0"'\e]0;\u@\h:\w' # : $(history -a; tail -1 ~/.bash_history)\a' adds full history after each command, spamming bash_history, if there are multiple bashs open

# colored returncode
PS1='\[\e[30;49;8m\]# $(rc=$?; [ $rc != 0 ] && echo "\[\e[0;31m\]=> $rc\[\e[m\] ")\[\e[0;33m\]\u\[\e[0;32m\]@\[\e[0;33m\]\h:\[\e[0;32m\]\w\n'
# set title
PS1="$PS1"'\[\e]0;\w\a\]'
#  prompt
PS1="$PS1"'\[\e[30;49;8m\]: \[\e[0;34m\]; '
