# ARUH (Admin Rights User Helper)

## Descrizione
Lo script `aruh.ps1` è uno script PowerShell progettato per semplificare l'esecuzione di un programma con privilegi amministrativi durante una chiamata su Microsoft Teams. Esso crea un file batch temporaneo e lo esegue con diritti elevati, avviando così il programma specificato come amministratore.

## Istruzioni

### Prerequisiti
Assicurarsi di seguire questi passaggi prima di utilizzare lo script:

1. **Spostamento dell'eseguibile**: Prima di tutto, spostare l'eseguibile del programma che si desidera avviare in una cartella in cui il percorso completo non contenga spazi o whitespaces.

2. **Aprire un terminale nella cartella dello script**: Tenere premuti i tasti SHIFT + Tasto DESTRO in un punto vuoto della cartella dello script e selezionare la voce "Apri finestra PowerShell qui".

### Esecuzione dello script

3. **Lanciare il comando PowerShell**: Eseguire il seguente comando nel terminale PowerShell:

    ```powershell
    powershell -ep bypass -file .\aruh.ps1 -f <percorso_del_file_da_avviare_come_amministratore> -u <la_tua_utenza_amministrativa>
    ```

4. **Inserire le credenziali amministrative**: Inserire la password dell'utenza amministrativa quando richiesto e premere INVIO.

5. **Confermare l'avvio del programma**: Informare l'utente che comparirà una finestra con due opzioni possibili ("Si" e "No"). Assicurarsi di premere "Si" per avviare il programma.

6. **Attendi l'avvio del programma**: Verrà avviato un altro terminale in modalità amministratore che verrà chiuso automaticamente dopo alcuni secondi, permettendo l'avvio del programma scelto all'inizio.

## Avvertenze
- Verificare che il percorso del file da avviare come amministratore sia corretto.
- Assicurarsi che l'utenza amministrativa fornita sia valida e abbia i privilegi necessari.

---
*Nota: Questo script è progettato per funzionare in un ambiente Windows. Assicurarsi di eseguire PowerShell con i permessi di esecuzione adeguati.*
