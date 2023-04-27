#!/bin/sh
# The srcipt opens an overview [1] of all layers of the NEOqwertz layout [2]
# with xviewer and closes it automatically. The mechanics aim to provide
# a quick possibility to search all layers for the desired letter/symbol.
#
# The script works best in combination with a global keyboard shortcut, f. e.
#   STRG + Ö
# (so handy that German has additional letters not used by any program).
# With the global keyboard shortcut you can "open, search, switch back and
# forget".
#
# [1]: An additional image containing all layers is necessary.
# [2]: https://www.neo-layout.org/Layouts/neoqwertz/

# Path to image file containing all layers
image_file="neo_gesamt.png"

xviewer $image_file &

# Delete if manual closing is preferred.
time_before_closing=10 # in seconds
sleep $time_before_closing
wmctrl -c $image_file # Close image viewer
