function _tsocks_prompt() {
	# White on Yellow
	if [ "${LD_PRELOAD/*libtsocks*/}" != "${LD_PRELOAD}" ]
	then
		echo -n "\[\e[0;37;43m\]tsocks\[\e[0m\] "
	fi
}
