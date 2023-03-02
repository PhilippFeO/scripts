#!/bin/bash

# This script saves all installes packages in "packages.list.save". This list can be used to reinstall
# everything on another machine or after new installing on the same machine.
# The script follows the commands in https://wiki.ubuntuusers.de/Paketverwaltung/Tipps/#Paketliste-zur-Wiederherstellung-erzeugen

path=/home/philipp/.backup-files

dpkg --get-selections | awk '$2 == "install" {print $1}' > $path/packages.list.save

# Saving package state
apt-mark showauto > $path/package-states-auto
apt-mark showmanual > $path/package-states-manual


# Tutorial for installing packages and their states
# xargs -a "packages.list.save" sudo apt-get install
# xargs -a "package-states-auto" sudo apt-mark auto
# xargs -a "package-states-manual" sudo apt-mark manual
