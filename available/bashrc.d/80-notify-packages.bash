[ -r "$HOME/tmp/.pacman-packages" ] &&
	[ "`wc -l < $HOME/tmp/.pacman-packages`" != 0 ] &&
	pacman -Quq > $HOME/tmp/.pacman-packages &&
	echo "there are new Packages: " `cat $HOME/tmp/.pacman-packages` ||
	true
