param(
	[parameter(Mandatory=$false)]
	[ValidateNotNullOrEmpty()]
	[String]$Software = "ADOTI")

$ADOTIInstalado = Get-WmiObject -Class Win32_Product | Where-Object {$_.name -match $Software}

if ($ADOTIInstalado -eq $null){
    Write-Host $Software + " nao esta instalado!"
}else{
    if ((Get-WmiObject Win32_OperatingSystem).OSArchitecture -match "64"){
        $ADOTIReg = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\" + $ADOTIInstalado.IdentifyingNumber
    }else{
        $ADOTIReg = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\" + $ADOTIInstalado.IdentifyingNumber
    }
    $command = (Get-Item -Path $ADOTIReg | Get-ItemProperty).UninstallString + " INSTALL_PASSWORD=6B6F637967667E6266212431"
    icm -command $command
    Wait-Process -Name msiexec
}
