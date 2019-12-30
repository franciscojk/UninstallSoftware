param(
	[parameter(Mandatory=$false)]
	[ValidateNotNullOrEmpty()]
	[String]$Software = "Remote Desktop")

$SoftwareInstalado = Get-WmiObject -Class Win32_Product | Where-Object {$_.name -match $Software}

if ($SoftwareInstalado -eq $null){
    Write-Host $Software + " nao esta instalado!"
}else{
    if ((Get-WmiObject Win32_OperatingSystem).OSArchitecture -match "64"){
        $ADOTIReg = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\" + $SoftwareInstalado.IdentifyingNumber
    }else{
        $ADOTIReg = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\" + $SoftwareInstalado.IdentifyingNumber
    }
    $command = ((Get-Item -Path $ADOTIReg | Get-ItemProperty).UninstallString + " INSTALL_PASSWORD=6B6F637967667E6266212431 /quiet").Replace("{","""{").Replace("}","}""")
    $setup = $command.Substring(0,11)
    $args = $command.Substring(12,$command.Length -12)

    Start-Process $setup -Wait -ArgumentList $args
}
