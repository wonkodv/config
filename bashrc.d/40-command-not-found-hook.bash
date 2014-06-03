command_not_found_handle () {
	local pkgs cmd=$1
	local FUNCNEST=10	#wat?

	printf "bash: $(gettext bash "%s: command not found")\n" "$cmd" >&2
	mapfile -t pkgs < <(pkgfile -b -- "$cmd" 2>/dev/null)
	if (( ${#pkgs[*]} )); then
		echo "${pkgs[@]}" > ~/tmp/.missing-packages
		echo "Packages that might help you:"
		for f in "${pkgs[@]}"
		do
			echo "	$f"
		done
		echo "Try: givemethat"
	fi
	return 127
}

givemethat(){
	select f in `cat ~/tmp/.missing-packages`
	do
		if [ -n "$f" ]
		then
			sudo pacman -S "$f"
			break
		fi
	done

}
