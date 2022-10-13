
if [[ -z "$DISPLAY" &&  $XDG_VTNR -eq 1 ]]
then
    read -t 5 -n 1 -p "StartX? [Y/n]: " check
    if [ "$check" == "" ] || [ "$check" == 'y' ] || [ "$check" == 'Y' ]
    then
        startx -- vt1
    fi
fi

