#!/bin/bash

# Skript, um verschlüsselte Dateien im Dateiexplorer „nemo“ per Rechtsklick zu entschlüsseln

# Löschen der verschlüsselten Datei muss getrennt, je nachdem ob Dateiendung vorhanden ist, behandelt werden, weil eine nachträgliche
# Unterscheidung schwierig ist, denn falls keine Dateiendung vorhanden ist, wird ".gpg" in "file_marker" gespeichert und diese Datei
# existiert immer, soll aber nicht immer gelöscht werden.

export PS4="\$LINENO: "
set -xv

# Verschlüsseltes Archiv aus Pfad extrahieren
IFS="/"
read -ra array <<< "$NEMO_SCRIPT_SELECTED_FILE_PATHS"
encrypted_file_name=${array[-1]}
#encrypted_file_name=~/Dokumente/Unterschriften2.tar.gpg

# Prüfen, ob Datei ausgewählt wurde
if [ "$encrypted_file_name" = "" ]; then
	notify-send "Keine Datei ausgewählt."
else
	# Name des Archivs aus „encrypted_file_name“ extrahieren
	IFS="."	# Trennt eingelesenen String am "."
	read -ra tmp <<< "$encrypted_file_name"
	# "tmp" hat drei Elemente: Dateiname, tar, gpg
	file_name=${tmp[0]}
	file_marker=${tmp[1]}				# Dateiendung "tar"
	encrypted_file_marker=${tmp[-1]}	# Dateiendung "gpg"

	# Nur Entschlüsselungsprozedur starten, wenn Datei über die Endung „gpg“ oder „asc“ verfügt
	if [[ "$encrypted_file_marker" = "gpg" || "$encrypted_file_marker" = "asc" ]]; then
		# Wenn Datei über Dateiendung, bspw. "tar" oder "txt", verfügt, wird diese an Ausgabedatei gehängt
		if [ ${#tmp[@]} -eq 3 ]; then	# s. oben
			file_name2="$file_name.$file_marker"
			zenity --info --no-wrap --text="Passwort in Zwischenablage kopiert?"
			gpg --decrypt --output "$file_name2" "$encrypted_file_name"	# Entschlüsseln
			if [ -f "$file_name2" ]; then			# Prüfen, ob entschlüsselt wurde, da man nur in diesem Fall die anderen Dateien löschen darf. Das Entschlüsseln kann auch biem Passwortdialog abgebrochen werden. 
				if [ "$file_marker" = "tar" ]; then	# Evtl. wurde ein Archiv dechiffriert
					tar -xf "$file_name2"			# Entpacken
					shred -fuz "$file_name2"		# sicher löschen des verpackten Archivs
				fi
				shred -fuz "$encrypted_file_name"	# sicheres löschen der verschlüsselten Datei
			fi
		else # Fall für Dateien, die über keine Dateiendungen wie .txt, .pdf, .tar verfügen
			zenity --info --no-wrap --text="Passwort in Zwischenablage kopiert?"
			gpg --decrypt --output "$file_name" "$encrypted_file_name"			# Entschlüsseln
			if [ -f "$file_name" ]; then	# Analog zu oben
				shred -fuz "$encrypted_file_name"
			fi
		fi
	else
		zenity --notification --text="„$encrypted_file_name“ ist nicht verschlüsselt."
	fi
fi
