function _ssh_prompt() {
	# white on blue
	if [ "$SSH_CLIENT" != "" ]
	then
		echo -n "\[\e[0;37;44m\]SSH\[\e[0m\] "
	fi
}
