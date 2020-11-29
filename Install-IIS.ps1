#Install IIS
Install-WindowsFeature -name Web-Server -IncludeManagementTools

#Remove default htm file
remove-item  C:\inetpub\wwwroot\iisstart.htm

#Add custom htm file 
 Add-Content -Path "C:\inetpub\wwwroot\iisstart.htm" -Value $("Hello World from " + $env:computername)

#Allow ICMPV4
New-NetFirewallRule -DisplayName AllowICMPv4 -Direction Inbound -Protocol ICMPv4 -IcmpType 8 -Action Allow

#Desligar a VM 
Stop-AzVM -ResourceGroupName "RG-VALIERE" -Name "SRV-API" -Force

#Generalizar a VM
Set-AzVm -ResourceGroupName "RG-VALIERE" -Name "SRV-API" -Generalized

# Get na VM 
$vm = Get-AzVM -Name "SRV-API" -ResourceGroupName "RG-VALIERE"

# Criação da "Image Custom" baseada na configuração da VM
$image = New-AzImageConfig -Location "eastus2" -SourceVirtualMachineId $vm.ID 

# Criar "Image Custom"
New-AzImage -Image $image -ImageName "SRV-API-IMAGEM-V1" -ResourceGroupName "RG-VALIERE"

