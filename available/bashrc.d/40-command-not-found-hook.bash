command_not_found_handle () {
	local pkgs cmd=$1
	printf "bash: $(gettext bash "%s: command not found")\n" "$cmd" >&2
	echo "Try givemethat to get it"
	echo "$cmd" > ~/tmp/.missing-packages
	return 127
}

givemethat(){
	cmd=`cat ~/tmp/.missing-packages`
	echo "packages that contain cmd $cmd:"
	mapfile -t pkgs < <(pkgfile -b -- "$cmd" 2>/dev/null)
	if (( ${#pkgs[*]} )); then
		select f in "${pkgs[@]}"
		do
			if [ -n "$f" ]
			then
				sudo pacman -S "$f"
				return 0
			fi
		done
	else
		echo "not found"
		return 1
	fi
}
