sshinfo="$HOME/tmp/.ssh-agent-info"
if [ ! -r "$sshinfo" ]; then
    ssh-agent >$sshinfo
    . "$sshinfo" >/dev/null
    ssh-add ~/.ssh/normal_rsa &>/dev/null
else
    . "$sshinfo" >/dev/null
fi
unset sshinfo
