

alias histhead='history | awk '\''{a[$2]++}END{for(i in a){print a[i]" "i}}'\'' | sort -rn | head'
alias doch="x='sudo `tail -n 1 $HOME/.bash_history`'; echo $x; $x"


alias stereo='ssh marvin bin/stereo '

s() {
	source ~/bin/s
}
