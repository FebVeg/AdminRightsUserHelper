
Clear-Host

Write-Host -ForegroundColor Black -BackgroundColor DarkCyan "`n Fabrizio Cagnini - ARUH.ps1 - Admin Rights User Helper "
Write-Host -ForegroundColor Black -BackgroundColor DarkGray " ARUH e' in grado di avviare script o eseguibili con i permessi amministrativi da programmi di condivisione schermo senza la possibilità di interagire tramite l'UAC"

###################################################################### Logger
$scriptPath         = split-path -parent $MyInvocation.MyCommand.Definition -ErrorAction SilentlyContinue # Recupero percorso completo dello script
$scriptName         = $MyInvocation.MyCommand.Name # Recupero nome dello script
$scriptName         = (Get-Item -Path "$scriptPath\$scriptName" -ErrorAction SilentlyContinue).BaseName # Elaboro il percorso dove verranno salvati i log
$global:scriptErrs  = @() # Errori / Eccezioni
$scriptUser         = $env:USERNAME
$scriptHost         = $env:COMPUTERNAME

if (-Not(Test-Path -Path "$scriptPath\log\")) {
    Write-Host -ForegroundColor Yellow "Preparazione di salvataggio output... 0/2`r" -NoNewline
    New-Item -Path "$scriptPath\" -Name "log" -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
    Write-Host -ForegroundColor Yellow "Preparazione di salvataggio output... 1/2`r" -NoNewline
    Start-Sleep -Seconds 1
    New-Item -Path "$scriptPath\log\" -Name "$scriptName.log" -ItemType File -ErrorAction SilentlyContinue | Out-Null
    Write-Host -ForegroundColor Yellow "Preparazione di salvataggio output... 2/2`r" -NoNewline
    Start-Sleep -Seconds 1
    Write-Host ""
}

Function Log ($livello, $log)
{
    try {
        # Elaboro la stringa di output del log ricevuto
        $log = "$(Get-Date -Format 'dd-MM-yyyy HH:mm:ss') [$scriptHost] ($scriptUser) $log"
        
        if ($livello -match "log") # Informazione 
        {
            Write-Host "[i] $log" -ForegroundColor Black -BackgroundColor White
            if (Test-Path "$scriptPath\log\$scriptName.log") { Add-Content -Path "$scriptPath\log\$scriptName.log" -Value "[i] $log" }
        } 
        
        elseif ($livello -match "err") # Errore
        {
            Write-Host "[!] $log" -ForegroundColor Black -BackgroundColor Red
            if (Test-Path "$scriptPath\log\$scriptName.log") { Add-Content -Path "$scriptPath\log\$scriptName.log" -Value "[!] $log" }
            $global:scriptErrs += "$log"
        } 
        
        elseif ($livello -match "ok") # Successo
        {
            Write-Host "[+] $log" -ForegroundColor Black -BackgroundColor Green
            if (Test-Path "$scriptPath\log\$scriptName.log") { Add-Content -Path "$scriptPath\log\$scriptName.log" -Value "[+] $log" }
        } 
        
        elseif ($livello -match "warn") # Avviso
        {
            Write-Host "[-] $log" -ForegroundColor Black -BackgroundColor Yellow
            if (Test-Path "$scriptPath\log\$scriptName.log") { Add-Content -Path "$scriptPath\log\$scriptName.log" -Value "[-] $log" }
        }

        Start-Sleep -Milliseconds 200
    } catch {
        Write-Host "[*] La funzione 'Log' ha riscontrato un problema: $($Error[0])" -ForegroundColor Red
    }
}
###################################################################### Logger


###################################################################### OpenFileDialog
Function OpenFileDialog () 
{
    Add-Type -assembly System.Windows.Forms
    #$PercorsoScr = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath('.\')
    log "log" "Creo l'oggetto OpenFileDialog..."
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.InitialDirectory = $initialDirectory
    $OpenFileDialog.Multiselect = $false
    log "log" "Apertura FileDialog..."
    $response = $OpenFileDialog.ShowDialog() 
    if ($response -eq "OK" ) { 
        if (Test-Path -Path ($OpenFileDialog.FileName).Replace('"', "").Replace(" ", "` ")) {
            log "ok" $OpenFileDialog.FileName
            return ($OpenFileDialog.FileName).Replace('"', "").Replace(" ", "` ")
        } else {
            log "err" "Errore: File non esistente o corrotto"
            return $false
        }
    } else {
        log "err" "Dialog interrotto o annullato"
        return $false
    }
}
###################################################################### OpenFileDialog


###################################################################### ARUH
try {
    Set-Location $env:USERPROFILE

    $eseguibile = OpenFileDialog
    if (-Not($eseguibile)) {
        log "err" "Annullato"
        return $false
    }

    log("Creazione script di esecuzione...")
    $sn = "ARUH_Script_n$(Get-Random -Minimum 1000 -Maximum 9999).bat"
    New-Item -Path "C:\Windows\Temp\" -Name "$sn" -Value '@echo off && start "" "$" && pause'.Replace("$", $eseguibile) -Force | Out-Null
    if (Test-Path -Path "C:\Windows\Temp\$sn") {
        log "ok" "Script di esecuzione creato"

        Write-Host -BackgroundColor DarkGray -ForegroundColor Black "`nScript di esecuzione: $(Get-Content "C:\Windows\Temp\$sn")`n"

        if ((Get-Content -Path "C:\Windows\Temp\$sn") -like "*$eseguibile*") {
            log "ok" "Script di esecuzione corretto"
        } 
        else {
            log "err" "Script di esecuzione risultato incorretto"
            return $false
        }
    } 
    else {
        log "err" "Script di esecuzione non creato"
        return $false
    }

    $credenziali = Get-Credential -UserName "<DOMAIN>\<Admin Username>" -Message "Per avviare il processo di esecuzione con diritti amministrativi è necessario inserire le corrette credenziali privilegiate."
    Start-Process Powershell.exe -Credential $credenziali -ArgumentList "-noprofile -command &{Start-Process Powershell -ArgumentList C:\Windows\Temp\$sn -verb runas}"
} 
Catch {
    log "err" $Error[0]
    return $false
}
###################################################################### ARUH