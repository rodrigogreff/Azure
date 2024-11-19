# Parâmetros do domínio
$DomainName = "greffcode.local" # Substitua pelo nome do seu domínio
$DomainUser = "adminazure@greffcode.local" # Substitua pelo usuário do domínio com permissão de junção
$DomainPassword = ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force # Substitua pela senha do usuário do domínio

# Criar credenciais do domínio
$DomainCredential = New-Object System.Management.Automation.PSCredential ($DomainUser, $DomainPassword)

# Adicionar a máquina ao domínio
Add-Computer -DomainName $DomainName -Credential $DomainCredential -Restart -Force
