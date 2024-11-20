param (
    [string]$OUPath,
    [string]$UsersData
)

# Função para criar usuários no Active Directory
function Create-ADUser {
    param (
        [string]$SamAccountName,
        [string]$DisplayName,
        [string]$Password,
        [string]$OUPath
    )
    try {
        # Verifica se o usuário já existe
        if (-not (Get-ADUser -Filter {SamAccountName -eq $SamAccountName} -ErrorAction SilentlyContinue)) {
            Write-Host "Criando usuário: $SamAccountName"
            New-ADUser -SamAccountName $SamAccountName `
                       -DisplayName $DisplayName `
                       -AccountPassword (ConvertTo-SecureString $Password -AsPlainText -Force) `
                       -PasswordNeverExpires $true `
                       -Enabled $true `
                       -Path $OUPath `
                       -PassThru | Out-Null
            Write-Host "Usuário $SamAccountName criado com sucesso."
        } else {
            Write-Host "Usuário $SamAccountName já existe, ignorando."
        }
    } catch {
        Write-Error "Erro ao criar o usuário $SamAccountName: $_"
    }
}

# Valida se o módulo Active Directory está disponível
if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
    Write-Error "O módulo Active Directory não está instalado. Certifique-se de que o AD PowerShell está configurado."
    exit 1
}

# Importa o módulo Active Directory
Import-Module ActiveDirectory

# Verifica se o arquivo de dados dos usuários existe
if (-not (Test-Path -Path $UsersData)) {
    Write-Error "O arquivo de dados $UsersData não foi encontrado."
    exit 1
}

# Lê os dados dos usuários do arquivo CSV
try {
    $users = Import-Csv -Path $UsersData
    foreach ($user in $users) {
        Create-ADUser -SamAccountName $user.SamAccountName `
                      -DisplayName $user.DisplayName `
                      -Password $user.Password `
                      -OUPath $OUPath
    }
    Write-Host "Processo de criação de usuários concluído."
} catch {
    Write-Error "Erro ao ler o arquivo CSV ou criar usuários: $_"
    exit 1
}
