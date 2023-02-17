#!/bin/bash
# Übersetzer mit Firefox und Suchstring aufrufen
# "--new-window" da das Fenster automatisch geschlossen werden soll, nachdem ich die Übersetzung gelesen habe und weggklickt habe
# Man kann zwar auch Reiter/Tabs schließen aber dann nur den aktuellen/offen, dh. ich müsste warten bis das Skript den Reiter/Tab schließt und kann nicht wegklicken, bzw. würde ich das tun schlösse sich ein anderer oder ich müsste auf diese Mechanik verzichten und sie manuell schließen und es würden sich ggfl. viele Übersetzer-Reiter/Tabs ansammeln.
sh -c 'firefox --new-window "https://www.linguee.de/deutsch-englisch/search?source=auto&query=$(xclip -o)"'

# Warte 10 Sekunden (damit man die Übersetzung anschauen kann)
sleep 10

# Schließe das Fenster, damit nicht zu viele Reiter/Fenster geöffnet werden
# https://askubuntu.com/questions/616738/how-do-i-close-a-new-firefox-window-from-the-terminal
# Liste alle Fenster, isoliere alle Zeilen mit Firefox und Linguee, nimm letztes Element (wmctrl sortiert Fenster nach Öffnungszeitpunkt, ergo das Neuste ist das Letzte), printe ersten Wert (Zeile ist tabellarisch sortiert, erster Wert ist Hex-Wert für Fenster)
# Schließe Fenster (-c), das zu jeweiligem Hex-Wert gehört (-i)
wmctrl -ic "$(wmctrl -l | grep '.*Linguee.*Mozilla Firefox' | tail -1 | awk '{ print $1 }')"
