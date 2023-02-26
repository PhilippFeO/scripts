#!/bin/bash
# This script downloads all VictorMono Nerdfonts from https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/VictorMono

for type in "Bold" "Extra-Light" "Light" "Medium" "Semi-Bold" "Thin"; do
    for flavor in "Italic" "Oblique" ""; do
        if [ $flavor != "" ]; then
            name_path="$type-$flavor"
            # Filename has no "-" in $type-part, ie "ExtraLight" not "Extra-Light"
            # URL-encode whitespace, otherwise wget has two arguments
            name_file="$(echo $type | sed 's/-//')%20$flavor"
        else
            name_path=$type 
            # s. above
            name_file=$(echo $name_path | sed 's/-//')
        fi
        wget "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/VictorMono/"$name_path"/complete/Victor%20Mono%20"$name_file"%20Nerd%20Font%20Complete.ttf"
        # In case GitHub detects to many requests
        sleep 1
    done
done

for original in Italic Oblique Regular; do
    wget "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/VictorMono/"$original"/complete/Victor%20Mono%20"$original"%20Nerd%20Font%20Complete.ttf"
    sleep 1
done
