# Nemo-Action_Cambia_data_modifica_file

## Nemo-Action: Cambiare la data di modifica dei file selezionati

Salve a tutti, questo è il mio primo progetto su **GitHub**... ci ho messo tutta una nottata! In parte per creare il codice .sh, in parte anche per capire solamente come funziona GitHub xD.

### Di che cosa si tratta?

Questa è una **Action** per il file manager **Nemo**, software libero e open-source e file manager ufficiale dell'**ambiente desktop Cinnamon**, per modificare con un click destro **la data di modifica di uno o più file** selezionati con il mouse.

### Quali file compongono la Action?

Questa Action è composta da due file:

* il file `Cambia_data_modifica_file.nemo_action` che è il file letto da Nemo per eseguire la Action e che contiene le istruzioni per leggere il secondo file (oltre a impostare il nome e l'icona che saranno visualizzati quando si fa click con il tasto destro una icona, e altre cosette varie - ne parlerò più avanti);
* il file `Cambia_data_modifica_file.sh` che contiene il bash vero e proprio che provvederà ad aiutarvi nella modifica della data dei file che avete selezionato.

### Procedimento:

Questi due file, per far si che la Action possa funzionare, devono essere messi **<ins>entrambi</ins>** nella cartella `.local/share/nemo/actions` (come per tutte le action di Nemo).
Dopodiché dovrete aprire questa cartella nel vostro terminale -solitamente, quando in Nemo vi trovate in tale cartella, facendo click in una parte vuota di essa con il tasto destro e scegliendo `Apri nel terminale`, oppure aprendo il terminale (CTRL+ALT+T) e inviando il comando `cd $HOME/.local/share/nemo/actions`- e rendete eseguibile il file `Cambia_data_modifica_file.sh` inviando il comando ´chmod +x Cambia_data_modifica_file.sh´.

Una volta che si è fatto questo, bisogna:

1. **Chiudere Nemo**: o come si fa normalmente dalla finestra del nostro amato file manager (facendo attenzione di aver chiuso tutte le eventuali altre finestre aperte di Nemo), oppure da Terminale inviando il comando`nemo -q`.
2. **Riaprire Nemo**: o come si fa normalmente (non vi scrivo come, credo lo sappiate molto bene!), oppure inviando il comando `nemo` nel vostro Terminale.

### Pronti, partenza, VIA!

Da adesso in poi, quando selezionerete uno o più file in Nemo, cliccando con il tasto destro su di essi, vedrete nel menù una nuova voce: `Modifica la data`.

![](assets/Menu.png)

Cliccandoci sopra partirà il processo vero e proprio contenuto nel file `.sh` per cambiare la data di modifica del file o dei file selezionati.

Prima di tutto si aprirà una finestra di dialogo di tipo calendario (`zenity --calendar`) dove potrete selezionare la nuova data, a vostro piacimento. Potete cambiare il giorno, il mese e l'anno direttamente da qui.

![](assets/Calendario.png)

Una volta dato l'OK, comparirà una nuova finestra di dialogo, un menu a tendina, nella quale potrete selezionare l'orario - per comodità è con incrementi di 30 minuti (00:00 - 23:30).

![](assets/Orario.png)

Date l'OK anche qui e vi comparirà l'ultima finestra di conferma...

![](assets/Completato.png)

...e la data di modifica del (o dei) file da voi selezionato sarà, come per magia, cambiata.

Facile vero?

---
Per adesso la finisco qui, sono letteralmente distrutto e tra poco più di un'ora devo essere ad un appuntamento (ed ho dormito... NIENTE!!!).

Prossimamente spiegherò su questa pagina cosa fanno esattamente i due file.
Inoltre metterò a disposizione altri 2 file che fanno la stessa, ma che creano anche dei backup dei file ai quali viene modificata la date, e salvano nella stessa cartella un file di Debug.

Oltre a questo ho già pronto la stessa Action... ma in lingua inglese. Creerò una nuova Repositery per questo.

Un saluto e tante buone cose a tutti,

@FranzBias (Francesco)
---
