
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
$yaml = (Get-Content -Path $SpecificationPath) -join "`r`n"

$loadedSpecification = powershell-yaml\ConvertFrom-Yaml -Yaml $yaml

# Check application specification structure
Assert-ApplicationSpecification -ApplicationSpecification $loadedSpecification


$specification = [ordered]@{
  application = @{
      roles = @{
        default=@{}
      }
      locations = @{}
  }
  environments=@{}
}

$loadedSpecification.application.roles.Keys | ForEach-Object {
  $specification.application.roles[$_] = $loadedSpecification.application.roles[$_]
}

$loadedSpecification.application.locations.Keys | ForEach-Object {
  $specification.application.locations[$_] = $loadedSpecification.application.locations[$_]
}

$specification.environments = $loadedSpecification.environments

$specification | ConvertTo-Yaml

# Check application specification after reload
Assert-ApplicationSpecification -ApplicationSpecification $specification

# Get the consolidated server attributes
$environmentName = "dev"
$environment = $specification.environments[$environmentName]
$servers = @{}
foreach($serverKey in $environment.servers.Keys)
{
  # 1. Start from server pecification
  write-verbose "1. Load $server $serverKey attributes"
  $server = $environment.servers[$serverKey].Clone()

  # 2. Load location specification defined for the environment
  if (($null -ne $server.server_location) -and $environment.locations.Contains($server.server_location))
  {
    write-verbose "2. Load location $($server.server_location) specification defined for the environment $environmentName for the server $serverKey"
    $server += $environment.locations[$server.server_location]
  }

  # 3. Load application role defined for the environment
  if (($null -ne $server.server_role) -and $environment.roles.Contains($server.server_role))
  {
    write-verbose "3. Load application role $($server.server_role) defined for the environment $environmentName for the server $($server.name)"
    $server += $environment.roles[$server.server_role]
  }

  # 4. Load application  default defined for the environment
  if ($environment.roles.Contains("default"))
  {
    write-verbose "4. Load application default defined for the environment $environmentName for the server $($server.name)"
    $server += $environment.roles["default"]
  }

  # 5. Load location specification defined globally
  if (($null -ne $server.server_location) -and $specification.application.locations.Contains($server.server_location))
  {
    write-verbose "5. Load location $($server.server_location) specification defined globally for the server $serverKey"
    $server += $specification.application.locations[$server.server_role]
  }

  # 6. Load role specification defined globally for the server
  if (($null -ne $server.server_role) -and $specification.application.roles.Contains($server.server_role))
  {
    write-verbose "6. Load role specification defined globally for the server $($server.name)"
    $server += $specification.application.roles[$server.server_role]
  }

  # 7. Load application default defined globally
  if ($specification.application.roles.Contains("default"))
  {
    write-verbose "7. Load role specification defined globally for the server $($server.name)"
    $server += $specification.application.roles["default"]
  }


  $server

}

