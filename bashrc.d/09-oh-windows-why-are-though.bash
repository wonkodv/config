# when running bash on Windows (mingw) home and user are not always set
if [ -z "$USER" ]; then
    export USER="$USERNAME"
fi
if [ -z "$HOME" ]; then
    export HOME=~
fi
