# Admin Rights User Helper
Questo scrippettino PowerShell permette di avviare eseguibili con permessi di amministratore durante il supporto tecnico remoto attraverso Teams o altri programmi che non consentono di interfacciarsi con l'UAC di Windows durante la condivisione dello schermo.

Non puoi capire quanto mi ha aiutato questo script! Ricordo ancora i silenzi imbarazzanti dopo aver detto all'utente: 
> "Hey... tu che stai tra la sedia e il monitor... ho pessime notizie per te, non posso aiutarti perché l'altro programma di controllo remoto non funge".

Ricorda sempre di non dare la colpa ai sistemi informatici, ma ad altre persone. 

## Guida
Se anche tu come me hai bisogno di dormire e di urlare allo stesso tempo, leggi questa guida. Ti calmerà durante la sessione di troubleshooting remota. 
Ti capiterà di chiamare, o esser chiamato da un utente che ha bisogno di installare qualche programma per un progetto mai sentito di cui ti importa poco (sii sincero). 

So che la prima cosa che gli chiederai sarà:
> "E' stato aperto un ticket, approvato dal tuo capo e dalla security?" 
E ti toccherai i maroni per speranza che ti risponda "No", così da continuare a far finta di lavorare scansafatiche bastardo. 

Ecco, sta volta ti ha risposto "Si" menasfighe. 
Quindi gli chiederai l'hostname della sua macchina per collegarti al suo computer usando il programmino che ti permetterà di avviare l'installer come admin ma... non funziona. 
E nemmeno via condivisione schermo di Teams potrai farlo perché non ti permetterà di interagire con l'UAC di Windows.

Ma ho trovato la soluzione al problema (non ai miei mentali lol), fatti condividere lo schermo via Teams e copiagli ARUH.ps1 in locale.
1. Apri un CMD e recati nella cartella dove hai copiato il ARUH.
2. Avvialo con il comando: 
```
powershell.exe -ExecutionPolicy Bypass -File ARUH.ps1
```
3. Si avvierà così lo script che ti chiederà di scegliere un file, dovrai selezionare l'installer del programma da installare all'utente.
Lo script effettuerà delle verifiche e scriverà un piccolo file .bat nella cartella:
> C:\Windows\Temp\<file_id>.bat
4. Lo script ti chiederà la tua utenza amministrativa (scrivi solo il tuo username amministrativo)
5. Controlla che il dominio che precede il tuo username admin sia corretto e inserisci la tua password amministrativa
6. Pigia ENTER
7. Lo script avvierà dal computer dell'utente quel .bat citato prima e chiederà all'utente di aprire la powershell come amministratore ma tu non lo vedrai. Per favore, digli di cliccare su "Si" prima che mi arrabbi.

Ecco fatto! Avrai avviato il tuo eseguibile come amministratore usando la condivisione schermo da Teams. 50€ grazie.


