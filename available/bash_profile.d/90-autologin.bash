_do_after_login()
{
	if ! lsusb | grep 'G510'
	then
		return 0
	fi

	sleep 5
	mpd&
	sleep 1
	mpc clear
	mpc load current
	mpc random on
	mpc repeat on
	mpc play
	sleep 4
	sudo pacman -Sy &&  pacman -Quq > ~/tmp/.pacman-packages
}

if [[ $XDG_VTNR -eq 1 ]]
then
	_do_after_login &>/dev/null &
	read -t 1 -n 1 -p "StartX? [Y/n]: " check
	if [ "$check" != "n" ] && [ "$check" != 'N' ]
	then
		exec startx -- vt1
	fi
fi

