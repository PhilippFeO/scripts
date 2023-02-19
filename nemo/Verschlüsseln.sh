#!/bin/bash

# Skript, um Dateien im Dateiexplorer „nemo“ per Rechtsklick zu verschlüsseln

function encrypt() {
	# $1	Resultat der Frage, ob man mit ASCII-Hülle (--armor) verschlüsseln möchte
	# $2	Name der zu verschlüsselnden Datei
	file=$2
	zenity --info --no-wrap --text="Passwort in Zwischenablage kopiert?"
	if [ $1 = 0 ]; then
			gpg --symmetric --armor --cipher-algo TWOFISH "$file"
		else
			gpg --symmetric --cipher-algo TWOFISH "$file"
	fi
}


# Falls man den Passwortdialog abbricht, wurde die Datei nicht chiffriert. In diesem Fall
# soll die Ursprungsdatei auch nicht gelöscht werden, da man sonst die Daten verlieren würde.
# Die Verschlüsselung wird per Endung ".gpg" oder ".asc" signalisiert.
function shred_helper() {
	# $1	Boolean		true = (tar-)Archiv,
	#					false = Datei
	# $2	String		Datei oder Archiv
	file_name=$2
	encrypted_file=$2	# Bei Archiven wird nur der Name, ohne Archivendung (.tar) übergeben. Der Name der kodierten Datei enthält diese jedoch. Deswegen wird sie im nächsten Schritt hinzugefügt
	if [ "$1" = true ]; then
		encrypted_file="$encrypted_file.tar"
	fi
	if [[ -f "$encrypted_file.gpg" || -f "$encrypted_file.asc" ]]; then
		if [ "$1" = true ]; then
			find "$file_name" -type f -print0 | xargs -0 shred -fuz
			rm -r "$file_name"
			shred -fuz "$file_name.tar"
		else
			shred -fuz "$file_name"
		fi
		zenity --notification --text="„$file_name“ ist nun verschlüsselt."
	fi
}


# Speichere Dateinamen, der sich am Ende von „NEMO_SCRIPT_CURRENT_URI“ befindet in „file_name“
IFS="/" # „IFS“ ist eine interne Variable, die irgendwie im „read“-Befehl verwendung findet
read -ra array <<< "$NEMO_SCRIPT_SELECTED_FILE_PATHS"
file_name=${array[-1]}

# Prüfen, ob Datei ausgewählt wurde
if [ "$file_name" = "" ]; then
	notify-send "Keine Datei ausgewählt."
else
	zenity --question --no-wrap --text="Mit ASCII-Hülle (--armor) verschlüsseln?"
	result=$?	# $? == 0: Ja, $? == 1: Nein
	if [ -d "$file_name" ]; then # Unterschied, ob Verzeichnis oder Datei
		# Ordner archivieren, um ihn als Datei zu verwalten (klappt nicht mit GnuPG, kann nur Dateien)
		archive_name="$file_name.tar"
		tar -cf "$archive_name" "$file_name"		
		# Archiv verschlüsseln
		encrypt $result $archive_name
		# Verzeichnis und Archiv sicher löschen
		shred_helper true $file_name
	else # Datei verschlüsseln
		encrypt $result $file_name
		# Ursprüngliche Datei sicher löschen
		shred_helper false $file_name
	fi
fi
