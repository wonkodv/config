#!/usr/bin/env bash
set -e
if ! git diff-index --quiet HEAD; then
    echo git dirty
    exit 1
fi
cd "$(dirname "$0")"
sudo nixos-rebuild switch --flake .
