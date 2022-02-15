#!/bin/bash

# remove existing symlink
rm ~/.config/nixpkgs || true

# set up symlink
ln -s "$(pwd)/nixfiles" ~/.config/nixpkgs
