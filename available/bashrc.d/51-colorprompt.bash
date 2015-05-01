function _render_color_prompt() {
	ret=$?

	echo -n "\[\e[0;36m\]"

	echo -n "\A "

	status="$(
	_returncode_prompt $ret
	_git_prompt
	_job_prompt
#	_svn_prompt
	_ssh_prompt
	_sudo_prompt
	_trickle_prompt
	_tsocks_prompt
#	_shlvl_prompt
	)"

	# WAT?
	local lstatus="`echo -n \"${status}\" | sed -e 's/\\\\\[[^]]*\\\\\]//g'`"
	lstatus=${#lstatus}

	if [ $COLUMNS -gt 80 ]
	then
		local len=80
	else
		local len=$COLUMNS
	fi
	len=$(($len-$lstatus+37));
	printf "%- ${len}s " "\[\e[0;33m\]$USER\[\e[0;36m\]@\[\e[33m\]$HOSTNAME:\[\e[36m\]$PWD"
	echo -n $status

	if [ "$TERM" == "xterm" ]
	then
		echo -n '\[\e]0;\u@\h\007\]' # titlebar 
	fi


	echo "\[\e[0m\]"				# clear, linebreak

	echo -n "\[\e[35m\]\! "			# History Number

	if [ "$USER" != 'root' ]
	then
		echo -n "\[\e[36m\]$ "
	else
		echo -n "\[\e[31m\]# "
	fi
	echo -n "\[\e[0m\]"				# clear
}

PROMPT_COMMAND='PS1="`_render_color_prompt`"'
