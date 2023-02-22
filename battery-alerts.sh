#!/bin/bash

# Run this script as a cronjob every 5 minutes or so, to get notifications when
# battery percentage goes below 30% or above 80%.
# Cronjob line example:
# */5 * * * * export DISPLAY=:0 && /home/philipp/Programmieren/Skripte/battery-alerts.sh

# Ich habe mich für eine Kombination aus <notify-send> und <zenity> entschieden, da die Benachrichtigungen
# bei <notify-send> schöner sind aber <zenity> unabhängige Fenster öffnet, sie nicht übersehen werden können. Das 
# nutze ich für die „letzte Warnung“ bevor der Akku entgültig leer ist.

# Notwendig, damit
#	- zenity --notification
#	- notify-send
# funktionieren.
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

LOWER_BOUNDARY_1=20
LOWER_BOUNDARY_2=10
UPPER_BOUNDARY=85
TITLE="Energiehinweis"
ICON_PATH_URGENT=/usr/share/icons/gnome/48x48/status/software-update-urgent.png
ICON_PATH_CHARGED=/usr/share/icons/gnome/48x48/status/battery-full-charging.png

# Unschön gelöst aber da Funktionen in bash keine Strings zurückgeben können, weiß ich nicht, wie man die Meldungen sauber zusammenbaut.
LOWER_BOUNDARY_1_MSG="Akku-Kapazität unter $LOWER_BOUNDARY_1%! Stromkabel einstecken und Lebensdauer zu schonen. :)"
LOWER_BOUNDARY_2_MSG="Akku-Kapazität unter $LOWER_BOUNDARY_2%! Stromkabel einstecken und Lebensdauer zu schonen. :)"
UPPER_BOUNDARY_MSG="Akku-Kapazität über $UPPER_BOUNDARY%. Kabel entfernen, um die Lebensdauer zu schonen."

BATTERY_PATH=$(upower -e | grep battery)
LINE_POWER_PATH=$(upower -e | grep line_power)
BATTERY_PERCENTAGE=$(upower -i $BATTERY_PATH | grep 'percentage:' | awk '{ print $2 }' | sed 's/%//')
CABLE_PLUGGED=$(upower -i $LINE_POWER_PATH | grep -A2 'line-power' | grep online | awk '{ print $2 }')

if [[ $CABLE_PLUGGED == 'yes' ]]; then

    # Notification if capacity is above $UPPER_BOUNDARY to unplug cable
    if [[ $BATTERY_PERCENTAGE -gt $UPPER_BOUNDARY ]]; then
	notify-send --icon=$ICON_PATH_CHARGED $TITLE "$UPPER_BOUNDARY_MSG"
    fi

else

    COND_1=$(($BATTERY_PERCENTAGE < $LOWER_BOUNDARY_1))
    COND_2=$(($BATTERY_PERCENTAGE < $LOWER_BOUNDARY_2))
    # Notification if capacity drops below $LOWER_BOUNDARY_1
    if [ $COND_1 == 1 ] && [ $COND_2 == 0 ]; then
	notify-send --icon=$ICON_PATH_URGENT $TITLE "$LOWER_BOUNDARY_1_MSG"
    fi

    # Notification if capacity drops below $LOWER_BOUNDARY_2
    if [ $COND_2 == 1 ]; then
	zenity --warning --title=$TITLE --text="$LOWER_BOUNDARY_2_MSG"
    fi

fi
