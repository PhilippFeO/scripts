#!/bin/sh
# Script for downloading high resolution images of Ernst Haeckel's "Kunstformen der Natur" from $url_stump into $dest_dir.

url_stump="http://www.biolib.de/haeckel/kunstformen/high/Tafel_"
dest_dir=~/Bilder/KunstformenDerNatur_ErnstHäckel/biolib/

mkdir $dest_dir

for image_type in "png" "jpg" "jpeg"; do
    for i in $(seq 0 9); do
        wget --directory-prefix=$dest_dir $url_stump"00"$i"_300."$image_type
    done
    for i in $(seq 10 99); do
        wget --directory-prefix=$dest_dir $url_stump"0"$i"_300."$image_type
    done
    for i in $(seq 100 999); do
        wget --directory-prefix=$dest_dir $url_stump$i"_300."$image_type
    done
done
