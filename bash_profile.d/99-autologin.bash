if [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]]; then
    read -n 1 -t 3 -p "Start? [X with awesome / Gnome wayland / Sway wayland / reboot Windows]: " check
    case "$check" in
    "" | x)
        startx -- vt1
        ;;
    s)
        sway
        ;;
    w)
        sudo efibootmgr -n 0001
        reboot
        ;;
    g)
        XDG_SESSION_TYPE=wayland dbus-run-session gnome-session
        ;;
    esac
fi
