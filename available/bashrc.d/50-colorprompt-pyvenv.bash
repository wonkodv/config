function _pyvenv_prompt() {
	# white on blue
	if [ "$VIRTUAL_ENV" != "" ]
	then
		echo -n "\[\e[0;37;44m\]${VIRTUAL_ENV##*/}\[\e[0m\] "
	fi
}
