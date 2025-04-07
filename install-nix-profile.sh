#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"

mkdir -p ~/code ~/.config/nix  ~/bin

if ! command -v nix > /dev/null
then
    sh <(curl -L https://nixos.org/nix/install) --no-daemon
fi

if [ -f ~/.nix-profile/etc/profile.d/nix.sh ]
then
    . ~/.nix-profile/etc/profile.d/nix.sh
fi

# we don't know the version of `nix` so we only let `.#nix` touch the profile to
# avoid incompatibillities if `nix` is older or newer. after profile install, we
# should be good as the profile comes early in PATH
if nix run ".#nix" profile list | grep $PWD >/dev/null
then
    # best intrface out there !!
    nix run .#nix -- profile upgrade "$( nix run .#nix -- profile list --json | jq -r ".elements | to_entries | .[] | select( .value.originalUrl == \"git+file://$PWD\") | .key " )"
else
    if [ -z "$1" ]
    then
        echo "specify which profile package to install (dev, desktop, ...)"
    else
        nix run ".#nix" -- profile install ".#$1"
    fi
fi
