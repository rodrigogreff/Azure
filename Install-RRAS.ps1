#Install RRAS

Install-WindowsFeature RemoteAccess

Install-WindowsFeature DirectAccess-VPN -IncludeManagementTool

Install-WindowsFeature Routing -IncludeManagementTools
