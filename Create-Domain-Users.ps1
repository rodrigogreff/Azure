Start-Transcript -Path "C:\Logs\Create-Domain-Users.log" -Append

if (-Not (Test-Connection -ComputerName "adds01" -Count 1 -Quiet)) {
    Write-Host "Domain Controller not reachable."
    exit 1
}

try {
    Import-Csv -Path './Users.csv' | ForEach-Object {
        Write-Host "Creating user: $($_.Name)"
        New-ADUser -Name $_.Name -GivenName $_.GivenName -Surname $_.Surname -UserPrincipalName $_.UserPrincipalName -AccountPassword (ConvertTo-SecureString $_.Password -AsPlainText -Force) -Enabled $true -PassThru
    }
    Write-Host "Users created successfully."
} catch {
    Write-Host "Error creating users: $_"
    exit 1
}

Stop-Transcript

# URL do arquivo CSV no GitHub
$csvUrl = "https://raw.githubusercontent.com/rodrigogreff/Azure/master/Users.csv"
# Caminho temporário para salvar o CSV
$csvPath = "C:\Temp\Users.csv"

# Baixar o arquivo CSV do GitHub
Invoke-WebRequest -Uri $csvUrl -OutFile $csvPath

# Verificar se o arquivo foi baixado com sucesso
if (Test-Path $csvPath) {
    Write-Host "Arquivo CSV baixado com sucesso."
} else {
    Write-Host "Falha ao baixar o arquivo CSV."
    exit 1
}

# Criar OU, caso ainda não exista
$ouGREFFCode = Get-ADOrganizationalUnit -Filter 'Name -eq "GREFFCode"' -ErrorAction SilentlyContinue
if (-not $ouGREFFCode) {
    Write-Host "Criando OU GREFFCode."
    New-ADOrganizationalUnit -Name "GREFFCode" -Path "DC=greffcode,DC=local"
}

$ouUsers = Get-ADOrganizationalUnit -Filter 'Name -eq "Users"' -SearchBase "OU=GREFFCode,DC=greffcode,DC=local" -ErrorAction SilentlyContinue
if (-not $ouUsers) {
    Write-Host "Criando OU Users."
    New-ADOrganizationalUnit -Name "Users" -Path "OU=GREFFCode,DC=greffcode,DC=local"
}

# Importar lista de usuários a partir do arquivo CSV usando csvde
Write-Host "Importando usuários."
csvde -i -f $csvPath -k

# Alterar senha e habilitar a conta
Write-Host "Alterando senhas e habilitando contas."
dsquery user "ou=Users,ou=GREFFCode,dc=greffcode,dc=local" | dsmod user -pwd "P@ssw0rd" -disabled no
