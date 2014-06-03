function _sudo_prompt() {
	# white on blue
	if ! [ -z "$SUDO_USER" ]
	then
		echo -n "\[\e[0;37;44m\]SUDO($SUDO_USER)\[\e[0m\] "
	fi
}
