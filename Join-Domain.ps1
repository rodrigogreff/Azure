# Parâmetros
param (
    [string]$DomainName,
    [string]$DomainUser,
    [string]$DomainPassword
)

# Converte a senha em um objeto seguro
$SecurePassword = ConvertTo-SecureString $DomainPassword -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($DomainUser, $SecurePassword)

# Adiciona a máquina ao domínio
Add-Computer -DomainName $DomainName -Credential $Credential -Force -Restart
