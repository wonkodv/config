# If connecting from SSH, set DISPLAY= and DBUS_SESSION to the value that some other process (the user is allowed to inspect
# has in its environment

if [[ -n "$SSH_CLIENT" && -z "$DISPLAY" ]]
then
    export $(strings /proc/*/environ 2>/dev/null | grep '^DISPLAY\|^DBUS_SESSION' | sort -u  | tail -2)
fi
