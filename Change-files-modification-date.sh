#!/bin/bash

set -e

# Detect system language
LANG_CODE=${LANG:0:2}

# Define translations
case "$LANG_CODE" in
    "it")
        MSG_NO_FILE="Nessun file selezionato."
        MSG_NO_DATE="Nessuna data selezionata. Uscita."
        MSG_NO_TIME="Nessun orario selezionato. Uscita."
        MSG_MOD_COMPLETE="Modifica completata!"
        MSG_BACKUP="Attiva il backup dei file."
        MSG_DEBUG="Attiva il debug (file di log)."
        MSG_YES="Sì"
        MSG_NO="No"
        MSG_CANCEL="Annulla"
        ;;
    "de")
        MSG_NO_FILE="Keine Datei ausgewählt."
        MSG_NO_DATE="Kein Datum ausgewählt. Beenden."
        MSG_NO_TIME="Keine Zeit ausgewählt. Beenden."
        MSG_MOD_COMPLETE="Änderung abgeschlossen!"
        MSG_BACKUP="Backup der Dateien aktivieren."
        MSG_DEBUG="Debug aktivieren (Log-Datei)."
        MSG_YES="Ja"
        MSG_NO="Nein"
        MSG_CANCEL="Abbrechen"
        ;;
    "fr")
        MSG_NO_FILE="Aucun fichier sélectionné."
        MSG_NO_DATE="Aucune date sélectionnée. Sortie."
        MSG_NO_TIME="Aucune heure sélectionnée. Sortie."
        MSG_MOD_COMPLETE="Modification terminée !"
        MSG_BACKUP="Activer la sauvegarde des fichiers."
        MSG_DEBUG="Activer le mode débogage (fichier journal)."
        MSG_YES="Oui"
        MSG_NO="Non"
        MSG_CANCEL="Annuler"
        ;;
    "es")
        MSG_NO_FILE="Ningún archivo seleccionado."
        MSG_NO_DATE="Ninguna fecha seleccionada. Salida."
        MSG_NO_TIME="Ninguna hora seleccionada. Salida."
        MSG_MOD_COMPLETE="¡Modificación completada!"
        MSG_BACKUP="Activar la copia de seguridad de archivos."
        MSG_DEBUG="Activar el modo de depuración (archivo de registro)."
        MSG_YES="Sí"
        MSG_NO="No"
        MSG_CANCEL="Cancelar"
        ;;
    "pt")
        MSG_NO_FILE="Nenhum arquivo selecionado."
        MSG_NO_DATE="Nenhuma data selecionada. Saindo."
        MSG_NO_TIME="Nenhuma hora selecionada. Saindo."
        MSG_MOD_COMPLETE="Modificação concluída!"
        MSG_BACKUP="Ativar backup de arquivos."
        MSG_DEBUG="Ativar modo de depuração (arquivo de log)."
        MSG_YES="Sim"
        MSG_NO="Não"
        MSG_CANCEL="Cancelar"
        ;;
    *) # Default to English
        MSG_NO_FILE="No file selected."
        MSG_NO_DATE="No date selected. Exiting."
        MSG_NO_TIME="No time selected. Exiting."
        MSG_MOD_COMPLETE="Modification completed!"
        MSG_BACKUP="Enable file backup."
        MSG_DEBUG="Enable debug mode (log file)."
        MSG_YES="Yes"
        MSG_NO="No"
        MSG_CANCEL="Cancel"
        ;;
esac

# Show options for backup and debug
BACKUP_ENABLED=1
DEBUG_ENABLED=1

if zenity --question --title="$MSG_BACKUP" --text="$MSG_BACKUP" --ok-label="$MSG_YES" --cancel-label="$MSG_NO"; then
    BACKUP_ENABLED=0
fi

if zenity --question --title="$MSG_DEBUG" --text="$MSG_DEBUG" --ok-label="$MSG_YES" --cancel-label="$MSG_NO"; then
    DEBUG_ENABLED=0
fi

# Enable debug logging if selected
debug_file="$(dirname "$1")/Debug.txt"
if [ "$DEBUG_ENABLED" -eq 0 ]; then
    echo "DEBUG LOG - $(date)" > "$debug_file"
fi

# Check dependencies
for dep in zenity touch; do
    if ! command -v "$dep" &>/dev/null; then
        zenity --error --text="Missing dependency: $dep. Install it with: sudo apt install $dep"
        exit 1
    fi
done

# Prompt for date
selected_date=$(zenity --calendar --title="$MSG_NO_DATE" --date-format="%Y%m%d")
if [ -z "$selected_date" ]; then
    zenity --error --text="$MSG_NO_DATE"
    exit 1
fi

# Prompt for time
hour_minute=$(zenity --list --title="$MSG_NO_TIME" --column="Time" "00:00" "00:30" "01:00" "01:30" "02:00" "02:30" "03:00" "03:30" "04:00" "04:30" "05:00" "05:30" "06:00" "06:30" "07:00" "07:30" "08:00" "08:30" "09:00" "09:30" "10:00" "10:30" "11:00" "11:30" "12:00" "12:30" "13:00" "13:30" "14:00" "14:30" "15:00" "15:30" "16:00" "16:30" "17:00" "17:30" "18:00" "18:30" "19:00" "19:30" "20:00" "20:30" "21:00" "21:30" "22:00" "22:30" "23:00" "23:30")

if [ -z "$hour_minute" ]; then
    zenity --error --text="$MSG_NO_TIME"
    exit 1
fi

hour=$(echo "$hour_minute" | cut -d ':' -f1)
minute=$(echo "$hour_minute" | cut -d ':' -f2)
timestamp="${selected_date}${hour}${minute}.00"

# Process each selected file
for file in "$@"; do
    if [ "$DEBUG_ENABLED" -eq 0 ]; then
        echo "Processing file: $file" >> "$debug_file"
    fi
    if [ "$BACKUP_ENABLED" -eq 0 ]; then
        cp --preserve=timestamps,mode,ownership "$file" "${file}.bkp"
    fi
    touch -t "$timestamp" -- "$file"
done

zenity --info --text="$MSG_MOD_COMPLETE"
