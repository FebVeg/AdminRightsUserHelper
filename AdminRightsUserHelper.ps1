
# This code helped me to install programs on computers without being able to use my administrative credentials. For example when a user shared his desktop to me from MS Teams.

$executable = Read-Host "Enter the path of the file you want to Run as administrator"
if (Test-Path -Path $executable) {
    $executable_script  = "helper.bat"
    $credenziali        = Get-Credential -UserName ($env:USERDOMAIN + "\") -Message "Enter your administrative credentials"
    Set-Location $env:USERPROFILE
    New-Item -Path "C:\Windows\Temp\" -Name "$executable_script" -Value '@echo off && start "" "$" && pause'.Replace("$", $executable) -Force
    Start-Process Powershell.exe -Credential $credenziali -ArgumentList "-noprofile -command &{Start-Process Powershell -ArgumentList C:\Windows\Temp\$executable_script -verb runas}"
} else {
    Write-Host ("File not found [" + $executable + "]")
}
