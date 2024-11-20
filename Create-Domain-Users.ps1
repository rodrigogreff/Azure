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

# Criar OU
New-ADOrganizationalUnit -Name "GREFFCode" -Path "DC=greffcode,DC=local"
New-ADOrganizationalUnit -Name "Users" -Path "OU=GREFFCode,DC=greffcode,DC=local"


# Importar lista de usuários a partir do arquivo CSV
csvde -i -f $csvPath -k

# Alterar senha e habilitar a conta
dsquery user "ou=Users,ou=GREFFCode,dc=greffcode,dc=local" | dsmod user -pwd "P@ssw0rd" -disabled no

