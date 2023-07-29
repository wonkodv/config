if [[ -z "$DISPLAY" &&  $XDG_VTNR -eq 1 ]]
then
    (
        sleep 20
        sudo pacman -Syu --downloadonly --noconfirm &>>~/tmp/.update-pacman
        ret=$(notify-send "Outdated Packages" "There are $(pacman -Sup | wc -l) new Packages" --expire-time=5000 --action=UPDATE="update now")
        if [ "$ret" == "UPDATE" ]
        then
            DISPLAY=:0 kitty --hold bash -x -c "sudo pacman -Su"
        fi
    )&
fi
