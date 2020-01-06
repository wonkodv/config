
if [[ -z "$DISPLAY" &&  $XDG_VTNR -eq 1 ]]
then
    read -t 1 -n 1 -p "StartX? [Y/n]: " check
    if [ "$check" != "n" ] && [ "$check" != 'N' ]
    then
        startx -- vt1
    fi
fi

