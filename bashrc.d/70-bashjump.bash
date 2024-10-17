if [ -f ~/code/bashjump/jump.bash ]
then
    BASHJUMP_HISTORY=~/.local/bashjump.sqlite
    source ~/code/bashjump/jump.bash
    if which sqlite3 &>/dev/null ; then
        bashjump_check_or_create_db
        function cd(){
            bashjump_cd "$@"
        }
        function j(){
            bashjump_jump "$@"
        }
    fi
fi
