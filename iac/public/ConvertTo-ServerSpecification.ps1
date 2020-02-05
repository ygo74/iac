function ConvertTo-ServerSpecification
{
  param(
    [Parameter(Mandatory=$true,ValueFromPipeline=$true, Position=0)]
    [ValidateNotNullOrEmpty()]
    [String]
    $Specification
  )
  process
  {
      # Read server specifications
      $server = powershell-yaml\ConvertFrom-Yaml -Yaml $Specification -ErrorAction Stop
      
      if ($null -eq $server.keys)
      {
          throw "Unable to parse from yaml"
      }
       
      # Check if missing mandatory attributes
      $diff = [Linq.Enumerable]::Except($MandatoryServerKeys, ([Object[]]$server.Keys))
      if ($diff.count -gt 0)
      {
        throw "Missing mandatory attributes in the server specifications.`r`n" + `
              "Mandatory attributes : $mandatoryKeys`r`n" + `
              "Object attributes : $([Object[]]$server.Keys)"
      }
      
      Write-Output $server
  }
}
