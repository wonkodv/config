#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"

mkdir -p ~/code ~/.config/nix ~/bin

function generate() {
    mkdir -p generated
    if [ ! -f generated/$1 ]; then
        {
            echo " # vim:ft=bash:"
            echo "### Generated"
            for f in $1.d/*.bash; do
                echo "source $PWD/$f";
            done
        }  > generated/$1
    fi
    ln -i $PWD/generated/$1 ~/.$1
}

generate bashrc
generate bash_profile
ln -i -s $PWD/gitconfig     ~/.gitconfig
ln -i -s $PWD/nvim          ~/.config/
ln -i -s $PWD/kitty         ~/.config/
ln -i -s $PWD/nix.conf      ~/.config/nix/nix.conf
touch ~/.bashrc_local
touch ~/.bash_profile_local
[ -d ~/code/bashjump ] || git clone https://github.com/wonkodv/bashjump ~/code/bashjump

for f in bin/*; do
    ln -i -s ${PWD}/$f ~/bin/
done

git config user.email wonko@hanstool.org
git config user.name wonko
