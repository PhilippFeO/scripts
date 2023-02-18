#!/bin/bash

# Skript, um per Rechtsklick leichter harte Links im Dateiexplorer „nemo“ anlegen zu können

# Speichere Dateinamen, der sich am Ende von „NEMO_SCRIPT_CURRENT_URI“ befindet in „file_name“
IFS="/" # „IFS“ ist eine interne Variable, die irgendwie im „read“-Befehl verwendung findet
read -ra array <<< "$NEMO_SCRIPT_SELECTED_FILE_PATHS"
file_name=${array[-1]}

# Prüfen, ob Datei ausgewählt wurde
if [ "$file_name" = "" ]; then
	notify-send "Keine Datei ausgewählt."
elif [ -d "$file_name" ]; then
	notify-send "Harte Links auf Verzeichnisse nicht möglich."
else
	# Auswahl des Verzeichnisses des Nutzers speichern
	#destination=$(zenity --entry --text="Zielverzeichnis für Datei „$file_name“ eingeben:")
	destination=$(zenity --file-selection --directory) 

	# „~“ durch „/home/philipp“ ersetzen, da sonst „ln“ nicht funktioniert
	tilde="~"
	replacement="/home/philipp"
	destination=${destination/$tilde/$replacement}
	
	# Harten Link erzeugen
	ln "$file_name" "$destination/$file_name"
fi
