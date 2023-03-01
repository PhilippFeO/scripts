#!/bin/bash
# This script downloads all VictorMono Nerdfonts from 
#   https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/VictorMono
# into $target_dir

target_dir=./VictorMonoNerdFont

function download() {
    # $1: Font name for path argument
    #       They might differ, f.i. ".../ExtraLight/..." and not ".../Extra-Light/..."
    # $2: Font name for file name
    wget --directory-prefix=$target_dir "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/VictorMono/"$1"/complete/Victor%20Mono%20"$2"%20Nerd%20Font%20Complete.ttf"
}

for type in "Bold" "Extra-Light" "Light" "Medium" "Semi-Bold" "Thin"; do
    # Filename has no "-" in $type-part, ie "ExtraLight" not "Extra-Light"
    name_file_stump=$(echo $type | sed 's/-//')
    for flavor in "Italic" "Oblique" ""; do
        if [ "$flavor" != "" ]; then
            name_path="$type-$flavor"
            # URL-encode whitespace, otherwise wget has two arguments
            name_file="$name_file_stump%20$flavor"
        else
            name_path=$type 
            name_file=$name_file_stump
        fi
        download $name_path $name_file
        # Precaution measurement, so ne requests are blocked by GitHub
        sleep 1
    done
done

for original in Italic Oblique Regular; do
    # $name_path and $name_file are the same in this case
    download $original $original
    # Precaution measurement, so ne requests are blocked by GitHub
    sleep 1
done
