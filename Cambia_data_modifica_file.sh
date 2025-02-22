#!/bin/bash

set -e

# Creare un file di debug nella stessa cartella del primo file selezionato
# Disabilitato il debug (commentato)
# debug_file="$(dirname "$1")/Debug.txt"
# echo "DEBUG LOG - $(date)" > "$debug_file"

# Creare un file temporaneo per salvare i nomi dei file ricevuti da Nemo
temp_file=$(mktemp)
for file in "$@"; do
    echo "$file" >> "$temp_file"
done

# echo "DEBUG: File ricevuti da Nemo:" >> "$debug_file"
# cat "$temp_file" >> "$debug_file"

# Verifica se sono stati passati file
if [ "$#" -eq 0 ]; then
    # echo "ERROR: Nessun file selezionato." >> "$debug_file"
    zenity --error --text="Nessun file selezionato."
    exit 1
fi

# Finestra di selezione della data usando un calendario
selected_date=$(zenity --calendar --title="Seleziona la data" --text="Scegli una nuova data di modifica" --date-format="%Y%m%d")
if [ -z "$selected_date" ]; then
    # echo "ERROR: Nessuna data selezionata." >> "$debug_file"
    zenity --error --text="Nessuna data selezionata. Uscita."
    exit 1
fi

# echo "DEBUG: Data selezionata: $selected_date" >> "$debug_file"

# Creazione della lista per il menu a tendina dell'orario
hour_minute=$(zenity --list --title="Seleziona l'orario" --text="Scegli un'ora e minuti" \
    --column="Orario" "00:00" "00:30" "01:00" "01:30" "02:00" "02:30" "03:00" "03:30" "04:00" "04:30" \
    "05:00" "05:30" "06:00" "06:30" "07:00" "07:30" "08:00" "08:30" "09:00" "09:30" \
    "10:00" "10:30" "11:00" "11:30" "12:00" "12:30" "13:00" "13:30" "14:00" "14:30" \
    "15:00" "15:30" "16:00" "16:30" "17:00" "17:30" "18:00" "18:30" "19:00" "19:30" \
    "20:00" "20:30" "21:00" "21:30" "22:00" "22:30" "23:00" "23:30")

if [ -z "$hour_minute" ]; then
    # echo "ERROR: Nessun orario selezionato." >> "$debug_file"
    zenity --error --text="Nessun orario selezionato. Uscita."
    exit 1
fi

# echo "DEBUG: Orario selezionato: $hour_minute" >> "$debug_file"

# Separare ora e minuti
hour=$(echo "$hour_minute" | cut -d ':' -f1)
minute=$(echo "$hour_minute" | cut -d ':' -f2)

# Formattare la data per touch
timestamp="${selected_date}${hour}${minute}.00"

# echo "DEBUG: Timestamp generato: $timestamp" >> "$debug_file"

# Iterare su tutti i file selezionati proteggendo i nomi con spazi e caratteri speciali
while IFS= read -r file; do
    # echo "DEBUG: Modificando il file: '$file'" >> "$debug_file"
    backup_file="${file}.bkp"
    # Disabilitato il backup (commentato)
    # cp --preserve=timestamps,mode,ownership "$file" "$backup_file"
    # echo "DEBUG: Backup creato: '$backup_file' con timestamp originale" >> "$debug_file"
    
    if touch -t "$timestamp" -- "$file"; then
        # echo "DEBUG: Data di modifica aggiornata con successo per '$file'" >> "$debug_file"
        :
    else
        # echo "ERROR: Fallita la modifica della data per '$file'" >> "$debug_file"
        :
    fi
done < "$temp_file"

# Pulizia del file temporaneo
rm -f "$temp_file"

# echo "DEBUG: Operazione completata." >> "$debug_file"
zenity --info --text="Modifica completata!"
