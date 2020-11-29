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
