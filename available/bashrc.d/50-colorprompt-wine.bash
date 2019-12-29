function _wine_prompt() {
	if [ "$WINEPREFIX" != "" ]
	then
		echo -n "\[\e[0;37;45m\]WINE\[\e[0m\] "
	fi
}
