

alias histhead='history | awk '\''{a[$2]++}END{for(i in a){print a[i]" "i}}'\'' | sort -rn | head'
alias doch='sudo `history -p "!!"`'


alias stereo='ssh marvin bin/stereo '

s() {
	source ~/bin/s
}

s -complete
