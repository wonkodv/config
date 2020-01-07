if [ -f ~/code/bashjump/jump.bash ]
then
    BASHJUMP_HISTORY=~/.config/bashjump.sqlite
    source ~/code/bashjump/jump.bash
    alias cd=bashjump_cd
    alias j=bashjump_jump
fi
