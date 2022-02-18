
Clear-Host

Set-Location $env:USERPROFILE

Write-Host -ForegroundColor Black -BackgroundColor Green " Fabrizio Cagnini - ARUH.ps1 - Admin Rights User Helper "


Function Log ($livello, $log) # Funzione di Logging
{
    # Elaboro la stringa di output del log ricevuto
    $log = "$(Get-Date -Format 'dd-MM-yyyy HH:mm:ss') $log"
    
    if ($livello -match "log") # Informazione 
    { Write-Host "[i] $log" -ForegroundColor Black -BackgroundColor White } 
    
    elseif ($livello -match "err") # Errore
    { Write-Host "[!] $log" -ForegroundColor Black -BackgroundColor Red } 
    
    elseif ($livello -match "ok") # Successo
    { Write-Host "[+] $log" -ForegroundColor Black -BackgroundColor Green } 
    
    elseif ($livello -match "warn") # Avviso
    { Write-Host "[-] $log" -ForegroundColor Black -BackgroundColor Yellow }
}


Function OpenFileDialog ()
{
    Add-Type -assembly System.Windows.Forms
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    if ($OpenFileDialog.ShowDialog() -match "OK" ) { 
        if (Test-Path -Path ($OpenFileDialog.FileName).Replace('"', "").Replace(" ", "` ")) { 
            return ($OpenFileDialog.FileName).Replace('"', "").Replace(" ", "` ") 
        } else { 
            log "err" "Percorso dell'eseguibile non valido" 
        }
    } else { 
        log "warn" "FileDialog chiuso oppure l'operazione è stata annullata"
        return 
    }
}

# Recupero l'eseguibile da avviare come admin
$eseguibile = OpenFileDialog

# Creo il nome dello script
$script_esecuzione = "ARUH_Script_n$(Get-Random -Minimum 1000 -Maximum 9999).bat"

# Creo lo script di esecuzione
New-Item -Path "C:\Windows\Temp\" -Name "$script_esecuzione" -Value '@echo off && start "" "$" && pause'.Replace("$", $eseguibile) -Force -ErrorAction Stop

# Aggiorno il terminale printando il contenuto dello script
Write-Host -BackgroundColor DarkGray -ForegroundColor Black "`nScript di esecuzione: $(Get-Content "C:\Windows\Temp\$script_esecuzione")`n"

# Verifico il contenuto dello script
if (-Not((Get-Content -Path "C:\Windows\Temp\$script_esecuzione") -like "*$eseguibile*"))
{ log "err" "Script di esecuzione non corretto!"; return }

# Recupero le credenziali amministrative
$credenziali = Get-Credential -UserName "<DOMAIN>\<Admin Username>" -Message "Per avviare il processo di esecuzione con diritti amministrativi è necessario inserire le corrette credenziali privilegiate." -ErrorAction Stop

# Avvio il processo powershell
Start-Process Powershell.exe -Credential $credenziali -ArgumentList "-noprofile -command &{Start-Process Powershell -ArgumentList C:\Windows\Temp\$script_esecuzione -verb runas}"
