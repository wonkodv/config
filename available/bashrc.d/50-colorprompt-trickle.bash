function _trickle_prompt() {
	# White on Blue
	if [ "${LD_PRELOAD/*trickle*/}" != "${LD_PRELOAD}" ]
	then
		echo -n "\[\e[0;37;44m\]Trickle up/down (KB/s): \[\e[1m\]${TRICKLE_UPLOAD_LIMIT}/${TRICKLE_DOWNLOAD_LIMIT}\[\e[0m\] "
	fi
}
