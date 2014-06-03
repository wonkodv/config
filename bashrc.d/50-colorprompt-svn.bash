function _svn_prompt() {
	# white on {red,yellow,green}
	if svn info 2> /dev/null > /dev/null
	then
		if [ "`svn status 2>/dev/null | wc -l`" == "0" ]
		then
			local color=42
		else
			if [ "`svn status | grep '^!\|?' | wc -l     `" == "0" ]
			then
			    local color=43
			else
				
			    local color=41
			fi
		fi
		echo -n "\[\e[0;30;${color}m\]svn\[\e[0m\] "
	fi
}
