function _shlvl_prompt() {
	# White on Blue
	if [ "2" != "$SHLVL" ]
	then
		echo -n "\[\e[0;37;44m\]ShellLevel: \[\e[1m\]${SHLVL}\[\e[0m\] "
	fi
}
