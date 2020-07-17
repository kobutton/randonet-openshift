# This powershell script thanks to this blog post:
# https://weblog.west-wind.com/posts/2017/may/25/automating-iis-feature-installation-with-powershell#Feedback

Set-ExecutionPolicy Bypass -Scope Process

Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServer
Enable-WindowsOptionalFeature -Online -FeatureName IIS-CommonHttpFeatures
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpErrors
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpRedirect
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ApplicationDevelopment

Enable-WindowsOptionalFeature -online -FeatureName NetFx4Extended-ASPNET45
Enable-WindowsOptionalFeature -Online -FeatureName IIS-NetFxExtensibility45
Enable-WindowsOptionalFeature -Online -FeatureName IIS-Security
Enable-WindowsOptionalFeature -Online -FeatureName IIS-RequestFiltering
Enable-WindowsOptionalFeature -Online -FeatureName IIS-Performance
Enable-WindowsOptionalFeature -Online -FeatureName IIS-WebServerManagementTools
Enable-WindowsOptionalFeature -Online -FeatureName IIS-StaticContent
Enable-WindowsOptionalFeature -Online -FeatureName IIS-DefaultDocument
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ApplicationInit
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ISAPIExtensions
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ISAPIFilter
Enable-WindowsOptionalFeature -Online -FeatureName IIS-HttpCompressionStatic

Enable-WindowsOptionalFeature -Online -FeatureName IIS-ASPNET45




Import-Module WebAdministration
Remove-WebSite -name "Default Web Site"
New-WebAppPool -name "randonet" -force

$appPool = Get-Item IIS:\AppPools\randonet
$appPool.processModel.identityType = "NetworkService"
$appPool | Set-Item

md "C:\randonet"
[net.ServicePointManager]::SecurityProtocol =[Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri https://github.com/kobutton/randonet/releases/download/1.0/app.publish.zip -OutFile C:\app.publish.zip

Expand-Archive -Path C:\app.publish.zip -DestinationPath C:\
mv C:\app.publish\* C:\randonet\
icacls C:\randonet\* /inheritance:E

$site = $site = new-WebSite -name "randonet" -PhysicalPath "C:\randonet" -ApplicationPool "randonet" -force

