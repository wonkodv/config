if ! [ -d ~/tmp ]; then
    rm ~/tmp
    ln -s -f $(mktemp -d) ~/tmp
fi
