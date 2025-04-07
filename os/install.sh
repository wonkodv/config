#!/usr/bin/env bash
cd "$(dirname "$0")"
sudo nixos-rebuild switch --flake .
