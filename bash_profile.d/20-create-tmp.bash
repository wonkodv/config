if ! [ -e ~/tmp ]; then
    rm -f ~/tmp # remove a stale symlink if exists (they don't `test -e`)
    ln -s $(mktemp -d) ~/tmp
fi
