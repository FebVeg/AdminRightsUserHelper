
# https://github.com/FebVeg

<# 
    * Tutorial *
    0) * ATTENZIONE: Spostate l'eseguibile in una cartella in cui il nome del percorso completo non abbia degli spazi o whitespaces (Es. C:\Users\Utente\Download\eseguibile.exe)
    1) Aprire un terminale nella cartella dello script corrente (aruh.ps1) tenendo premuto il tasto SHIFT + Tasto DESTRO in un punto vuoto della cartella dello script
    2) Selezionare la voce "Apri finestra PowerShell qui"
    3) Lanciare questo comando
        powershell -ep bypass -file .\aruh.ps1 -f <percorso_del_file_da_avviare_come_amministratore> -u <la_tua_utenza_amministrativa>
    4) Inserire la password della tua utenza amministrativa e premere INVIO
    5) Avvisare l'utente che comparirà una finestrella con due opzioni possibili "Si" e "No". Ditegli che deve premere "Si".
    6) Verrà avviato un altro terminale in modalità amministratore che verrà chiuso in automatico dopo 5 secondi permettendo l'avvio del programma scelto all'inizio
#>

param (
    [string]$u,
    [string]$f
)

if (($f.Length -eq 0) -or ($u.Length -eq 0)) {
    Write-Host -ForegroundColor Red     "`n`nParametri non validi"
    Write-Host -ForegroundColor Yellow  "Es: powershell -ep bypass -file .\aruh.ps1 -u <la_tua_utenza_amministrativa> -f <percorso_del_file_da_avviare_come_amministratore>`n`n"
    Exit
} else { Clear-Host }

Set-Location $env:USERPROFILE

if (Test-Path -Path $f) 
{   
    $batch_name = 'support_hd.bat'
    $batch_code = '@echo off && start "" "{0}" && timeout 2' -f $f
    $credentials = Get-Credential -UserName ($env:USERDOMAIN + "\" + $u) -Message "Enter your administrative credentials"
    try { New-Item -Path "C:\Windows\Temp" -Name $batch_name -Value $batch_code -Force | Out-Null} catch { Write-Host $Error[0] }
    Start-Process Powershell.exe -Credential $credentials -ArgumentList "-NoProfile -Command &{Start-Process Powershell -ArgumentList C:\Windows\Temp\$batch_name -Verb RunAs}"
} 
else { Write-Host "Il percorso non esiste" }
