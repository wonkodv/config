if [ -f ~/code/bashjump/jump.bash ]
then
    BASHJUMP_HISTORY=~/.config/bashjump.sqlite
    source ~/code/bashjump/jump.bash
    function cd(){
        bashjump_cd "$@"
        pwd
    }
    function j(){
        bashjump_jump "$@"
        pwd
    }
    bashjump_check_or_create_db
fi
