function _returncode_prompt() {
	# white on red
	# needs retcode as 1st param
	ret=$1
	if [ "$ret" != "0" ]
	then
        	echo -n "\[\e[0;37;41m\]$ret\[\e[0m\] "
	fi
}
