#!/bin/bash

# Script to open the help page $1 directly in Neovim
# Best use with a bash alias, like "nvimh $1" (s. ~/.bash_aliases)

if [ "$#" -ne 1 ]; then
    echo "Usage: ./nvim-help.sh <HELP PAGE>"
else
    nvim -c ":help $1 | only"
fi
