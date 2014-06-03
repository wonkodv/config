# assuming ~/tmp is a symlink to a folder 
# on a tmpfs, create the directory

tmp=`readlink -f /home/mr/tmp`
[ ! -w "$tmp" ] && mkdir "$tmp"
unset tmp
