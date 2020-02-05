
$module = Get-Module -ListAvailable | Where-Object {$_.Name -eq 'powershell-yaml'}
if ($null -eq $module)
{
    Install-Module -Name powershell-yaml -AllowClobber
}

import-module powershell-yaml -Force


$ServerSpecification = @"
  server_name: win_2
  server_location: usa
  server_environment: dev
  server_cpu: 2
"@

import-module .\iac\iac.psd1 -Force
$server = ConvertTo-ServerSpecification -Specification $ServerSpecification


$SpecificationPath = "samples\application_specifications.yml"
import-module .\iac\iac.psd1 -Force

$specification = Get-ApplicationSpecification -SpecificationPath $SpecificationPath

$servers = @{}

Get-ApplicationEnvironmentSpecification -Specification $specification -EnvironmentName dev | ForEach-Object {
  $server = New-Object -TypeName psobject -Property $_
  $servers.Add($_.server_name, $server)
}

$servers.Values

