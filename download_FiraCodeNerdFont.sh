#!/bin/sh
# Download FiraCode NerdFont from
#   https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode
# into $target_dir

target_dir="./FiraCodeNerdFont"

for type in Bold Light Medium Regular Retina SemiBold; do
    wget --directory-prefix=$target_dir "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FiraCode/"$type"/complete/Fira%20Code%20"$type"%20Nerd%20Font%20Complete.ttf"
done
