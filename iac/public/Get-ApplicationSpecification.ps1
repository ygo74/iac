function Get-ApplicationSpecification
{
  param(
    [Parameter(Mandatory=$true,ValueFromPipeline=$true, Position=0)]
    [ValidateNotNullOrEmpty()]
    [String]
    $SpecificationPath

  )
  process
  {
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

    # Check application specification after reload
    Assert-ApplicationSpecification -ApplicationSpecification $specification

    Write-Output $specification

  }
}
