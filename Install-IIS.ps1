#Install IIS
Install-WindowsFeature -name Web-Server -IncludeManagementTools

#Remove default htm file
remove-item  C:\inetpub\wwwroot\iisstart.htm

#Add custom htm file 
 Add-Content -Path "C:\inetpub\wwwroot\iisstart.htm" -Value $("Hello World from " + $env:computername)

#Allow ICMPV4
New-NetFirewallRule -DisplayName AllowICMPv4 -Direction Inbound -Protocol ICMPv4 -IcmpType 8 -Action Allow

#Desligar a VM 
Stop-AzureRmVM -ResourceGroupName "RG-VALIERE" -Name "SRV-API" -Force

#Generalizar a VM
Set-AzureRmVM -ResourceGroupName "RG-VALIERE" -Name "SRV-API" -Generalized

# Get na VM 
$vm = Get-AzureRmVM -Name "SRV-API" -ResourceGroupName "RG-VALIERE"

# Criação da "Image Custom" baseada na configuração da VM
$image = New-AzureRmImageConfig -Location "eastus2" -SourceVirtualMachineId $vm.ID 

# Criar "Image Custom"
New-AzureRmImage -Image $image -ImageName "SRV-API-IMAGE-V1" -ResourceGroupName "RG-VALIERE"

