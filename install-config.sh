#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"

mkdir -p ~/code ~/.config/nix ~/bin

function generate() {
    mkdir -p generated
    if [ ! -f generated/$1 ]; then
        {
            echo "### Generated"
            for f in $1.d/*.bash; do
                echo "source $PWD/$f"
            done
        } >generated/$1
    fi
    ln -f $PWD/generated/$1 ~/.$1
}

generate bashrc
generate bash_profile
ln -f -s $PWD/gitconfig ~/.gitconfig
ln -f -s $PWD/nvim ~/.config/
ln -f -s $PWD/kitty ~/.config/
ln -f -s $PWD/nix.conf ~/.config/nix/nix.conf
touch ~/.bashrc_local
touch ~/.bash_profile_local
[ -d ~/code/bashjump ] || git clone https://github.com/wonkodv/bashjump ~/code/bashjump

for f in bin/*; do
    ln -f -s ${PWD}/$f ~/bin/
done
