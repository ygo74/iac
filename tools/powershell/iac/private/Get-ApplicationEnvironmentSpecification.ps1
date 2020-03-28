function Get-ApplicationEnvironmentSpecification
{
  param(
    [Parameter(Mandatory=$true,ValueFromPipeline=$true, Position=0)]
    [ValidateNotNullOrEmpty()]
    [System.Collections.Hashtable]
    $Specification,

    [Parameter(Mandatory=$true,ValueFromPipeline=$true, Position=1)]
    [ValidateNotNullOrEmpty()]
    [String]
    $EnvironmentName

  )
  process
  {

    # Get the consolidated server attributes
    $environment = $specification.environments[$environmentName]
    foreach($serverKey in $environment.servers.Keys)
    {
    # 1. Start from server pecification
    write-verbose "1. Load $server $serverKey attributes"
    $server = $environment.servers[$serverKey].Clone()
    $server.Add("server_name", $serverKey)
    $server.Add("server_environment", $environmentName)


    # 2. Load location specification defined for the environment
    if (($null -ne $server.server_location) -and `
        ($null -ne $environment.locations) -and `
        $environment.locations.Contains($server.server_location))
    {
        write-verbose "2. Load location $($server.server_location) specification defined for the environment $environmentName for the server $serverKey"
        Merge-Hashtables -Reference $server -New $environment.locations[$server.server_location]
    }

    # 3. Load application role defined for the environment
    if (($null -ne $server.server_role) -and `
        ($null -ne $environment.roles) -and `
        $environment.roles.Contains($server.server_role))
    {
        write-verbose "3. Load application role $($server.server_role) defined for the environment $environmentName for the server $($server.name)"
        Merge-Hashtables -Reference $server -New $environment.roles[$server.server_role]
    }

    # 4. Load application  default defined for the environment
    if (($null -ne $environment.roles) -and $environment.roles.Contains("default"))
    {
        write-verbose "4. Load application default defined for the environment $environmentName for the server $($server.name)"
        Merge-Hashtables -Reference $server -New $environment.roles["default"]
    }

    # 5. Load location specification defined globally
    if (($null -ne $server.server_location) -and `
        ($null -ne $specification.application.locations) -and `
        $specification.application.locations.Contains($server.server_location))
    {
        write-verbose "5. Load location $($server.server_location) specification defined globally for the server $serverKey"
        Merge-Hashtables -Reference $server -New $specification.application.locations[$server.server_location]
    }

    # 6. Load role specification defined globally for the server
    if (($null -ne $server.server_role) -and `
        ($null -ne $specification.application.roles) -and `
        $specification.application.roles.Contains($server.server_role))
    {
        write-verbose "6. Load role specification defined globally for the server $($server.name)"
        Merge-Hashtables -Reference $server -New $specification.application.roles[$server.server_role]
    }

    # 7. Load application default defined globally
    if (($null -ne $specification.application.roles) -and $specification.application.roles.Contains("default"))
    {
        write-verbose "7. Load role specification defined globally for the server $($server.name)"
        Merge-Hashtables -Reference $server -New $specification.application.roles["default"]
    }

    Write-Output $server

    }

  }
}
