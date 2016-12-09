
if [[ -z "$DISPLAY" &&  $XDG_VTNR -eq 1 ]]
then
    autostart &>/dev/null &
    read -t 1 -n 1 -p "StartX? [Y/n]: " check
    if [ "$check" != "n" ] && [ "$check" != 'N' ]
    then
        exec startx -- vt1
    fi
fi

