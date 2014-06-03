function _job_prompt() {
	# white on blue
	local str=`jobs -p | wc -l`
	if [ "$str" != "0" ]
	then
		echo -n "\[\e[0;37;44m\]Jobs(\[\e[1m\]${str})\[\e[0m\] "
	fi
}
