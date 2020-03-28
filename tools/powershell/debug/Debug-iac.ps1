
$module = Get-Module -ListAvailable | Where-Object {$_.Name -eq 'powershell-yaml'}
if ($null -eq $module)
{
    Install-Module -Name powershell-yaml -AllowClobber
}

import-module powershell-yaml -Force
# or ??
import-module FXPSYaml

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

foreach($environment in $specification.environments.Keys)
{
  Get-ApplicationEnvironmentSpecification -Specification $specification -EnvironmentName $environment | ForEach-Object {
    $server = New-Object -TypeName psobject -Property $_
    $servers.Add($_.server_name, $server)
  }
}

$servers.Values

# 1.Create a list of full available properties
$allProperties = @()
foreach($server in $servers.Values) {
  $server | Get-Member -MemberType NoteProperty | ForEach-Object {
    $allProperties += $_.Name
  }
}

$properties = $allProperties | Sort-Object -Unique
$properties

# 2. Create an empty specification
$newSpecification = [ordered]@{
  application = @{
      roles = @{
        default=@{}
      }
      locations = @{}
  }
  environments=@{}
}

# 3. Add the default application structure
$applicationRoles     = $servers.Values | Group-Object server_role | Select-Object -ExpandProperty Name
$applicationLocations = $servers.Values | Group-Object server_location | Select-Object -ExpandProperty Name
$applicationEnvironments = $servers.Values | Group-Object server_environment | Select-Object -ExpandProperty Name

$applicationRoles | ForEach-Object { $newSpecification.application.roles.Add($_, @{}) }
$applicationLocations | ForEach-Object { $newSpecification.application.locations.Add($_, @{}) }

$applicationEnvironments | ForEach-Object {

  $environmentSpecification = [ordered]@{
      roles = @{
        default=@{}
      }
      locations = @{}
      servers = @{}
  }

  $applicationRoles | ForEach-Object { $environmentSpecification.roles.Add($_, @{}) }
  $applicationLocations | ForEach-Object { $environmentSpecification.locations.Add($_, @{}) }

  $newSpecification.environments.Add($_, $environmentSpecification)
}

$newSpecification | ConvertTo-Json | ConvertFrom-Json | ConvertTo-Yaml -OutFile D:\devel\github\iac\test.yaml


class Disk {
  [String]$Label
  [String]$drive_letter
  [Int32]$Capacity


  Disk() {}
}

class Server {
  Server(){}
  [Disk[]]$server_disk
  [String]$server_location
  [String]$server_role
}

$t = New-Object -TypeName Disk
$t.Capacity = 50
$t.Label = "Data"
$t.DriveLetter = "D:"

$diskJson = $t | ConvertTo-Json
$diskFromJson = [Disk]($diskJson | ConvertFrom-Json)


$servers.Values | ? {$_.server_environment -eq "uat"} | % {$_.server_disk}

$servers.Values | ? {$_.server_environment -eq "dev"} | Group-Object {
  $test = ""
  foreach($disk in  $_.server_disk)
  {
    $test += "$($disk.drive_letter)$($disk.capacity)"
  }
  $test
}



$propertyName = "server_disk"
$dynamicGroup = {
  $test = ""
  foreach($disk in  $_.$($propertyName))
  {
    $properties = $disk.keys # | Get-Member -MemberType NoteProperty
    foreach($property in $properties)
    {
      $test += $disk.$($property)
    }
  }
  $test
}

$servers.Values | ? {$_.server_environment -eq "dev"} | Group-Object $dynamicGroup